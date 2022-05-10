state("Bendy and the Ink Machine") {}

startup
{
	vars.Dbg = (Action<dynamic>) ((output) => print("[BatIM ASL] " + output));

	vars.Objectives = new[] { 12, 9, 18, 13, 13 };
	for (int i = 0; i < vars.Objectives.Length; ++i)
	{
		string parent = "Chapter " + (i + 1);
		settings.Add(parent);
		for (int j = 0; j < vars.Objectives[i]; ++j)
		{
			settings.Add("Ch-" + i + "_Obj-" + j + "_IsCompleted", false, "Objective " + (j + 1), parent);
		}
	}
}

init
{
	vars.TokenSource = new CancellationTokenSource();
	vars.ScanSuccess = false;

	Action<IntPtr, IntPtr> MakePtrs = (gMan, sMan) =>
	{
		var ObjectiveSaveDataVO = new Dictionary<string, int>
		{
			{ "IsStarted", 0x10 },
			{ "IsCompleted", 0x11 }
		};

		vars.ChapterWatchers = new MemoryWatcherList();
		for (int i = 0; i < vars.Objectives.Length; ++i)
		{
			for (int j = 0; j < vars.Objectives[i]; ++j)
			{
				foreach (var VOData in ObjectiveSaveDataVO)
				{
					string name = "Ch-" + i + "_Obj-" + j + "_" + VOData.Key;
					vars.ChapterWatchers.Add(
						new MemoryWatcher<bool>(
							new DeepPointer(gMan, 0x28, 0x18, 0x20 + 0x8 * i, 0x28 + 0x8 * j, VOData.Value)
						) { Name = name }
					);
				}
			}
		}

		vars.PlayTime = new MemoryWatcher<float>(new DeepPointer(gMan, 0x28, 0x18, 0x54));

		vars.UpdateScenes = (Action) (() =>
		{
			current.ThisScene = new DeepPointer(sMan, 0x50, 0x0, 0x18, 0x0).Deref<int>(game);
			current.NextScene = new DeepPointer(sMan, 0x28, 0x0, 0x18, 0x0).Deref<int>(game);
		});
	};

	vars.ScanThread = new Thread(() =>
	{
		vars.Dbg("Starting sig thread.");

		SignatureScanner MonoScanner = null, UnityScanner = null;

		var GameManager = IntPtr.Zero;
		var GameManagerSig = new SigScanTarget(3, "48 89 05 ???????? E8 ???????? 48 8D 0D ???????? 48 89 05 ???????? E8 ???????? 33 C9");
		GameManagerSig.OnFound = (p, s, ptr) =>
		{
			ptr = ptr + p.ReadValue<int>(ptr) + 0x4;
			new DeepPointer(ptr, 0x10, 0x1D0, 0x8, 0x3F0, 0x3A0, 0x108, 0x100, 0x8, 0x18, 0x0).DerefOffsets(p, out ptr);
			return ptr;
		};

		var SceneManager = IntPtr.Zero;
		var SceneManagerSig = new SigScanTarget(3, "4C 8B 2D ???????? B9 D0 00 00 00");
		SceneManagerSig.OnFound = (p, s, ptr) => ptr + p.ReadValue<int>(ptr) + 0x4;

		bool ModulesFound = false;
		var Token = vars.TokenSource.Token;

		while (!Token.IsCancellationRequested)
		{
			if (!ModulesFound)
			{
				var Modules = game.ModulesWow64Safe();
				var Mono = Modules.FirstOrDefault(m => m.ModuleName == "mono.dll");
				var UnityPlayer = Modules.FirstOrDefault(m => m.ModuleName == "UnityPlayer.dll");

				if (new[] { Mono, UnityPlayer }.Any(m => m == null))
				{
					vars.Dbg("One or more modules was null. Trying again.");
					Thread.Sleep(2000);
					continue;
				}

				MonoScanner = new SignatureScanner(game, Mono.BaseAddress, Mono.ModuleMemorySize);
				UnityScanner = new SignatureScanner(game, UnityPlayer.BaseAddress, UnityPlayer.ModuleMemorySize);
				ModulesFound = true;
			}

			if (GameManager == IntPtr.Zero && (GameManager = MonoScanner.Scan(GameManagerSig)) != IntPtr.Zero)
			{
				vars.Dbg("Found GameManager: 0x" + GameManager.ToString("X"));
			}

			if (SceneManager == IntPtr.Zero && (SceneManager = UnityScanner.Scan(SceneManagerSig)) != IntPtr.Zero)
			{
				vars.Dbg("Found SceneManager: 0x" + SceneManager.ToString("X"));
			}

			if (new[] { GameManager, SceneManager }.Any(a => a == IntPtr.Zero))
			{
				vars.Dbg("Not all signatures resolved. Trying again.");
				Thread.Sleep(2000);
				continue;
			}

			MakePtrs(GameManager, SceneManager);
			vars.ScanSuccess = true;
			break;
		}

		vars.Dbg("Exiting sig thread.");
	});

	vars.ScanThread.Start();
}

update
{
	if (!vars.ScanSuccess) return false;
	vars.UpdateScenes();
	vars.PlayTime.Update(game);
	vars.ChapterWatchers.UpdateAll(game);
}

exit
{
	vars.TokenSource.Cancel();
}

shutdown
{
	vars.TokenSource.Cancel();
}
