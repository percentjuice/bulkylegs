package
{
	import com.percentjuice.bulkyLegs.BulkyLegsContext;
	import com.percentjuice.bulkyLegs.ITest;
	import com.percentjuice.bulkyLegs.TestLoader;
	import com.percentjuice.bulkyLegs.events.TestResultsEvent;
	import com.percentjuice.bulkyLegs.services.bulkyLegsInterface.IInjectorService;

	import flash.display.Sprite;

	[SWF(width='50', height='50', backgroundColor='#cccccc', frameRate='30')]	
	public class BulkyLegsTestSuite extends Sprite implements ITest
	{
		public static const LOAD_ARRAY:Array = ['english', XMLIDNames.PRELOAD, XMLIDNames.NATURE,XMLIDNames.STRUCTURES,XMLIDNames.PEOPLE];
		public static const PATHS:Object = {assetsPath:'assets/',modelName:'assetsLoaded.xml'};			

		private var pc:BulkyLegsContext;
		private var inj:IInjectorService;

		public function BulkyLegsTestSuite()
		{
			super();
			init();
			run();
		}

		private function init():void
		{
			pc = new BulkyLegsContext(PATHS.assetsPath,PATHS.modelName);
			inj = pc.injectorService;
		}

		public function run():void
		{
			var test1:TestLoader = new TestLoader(TestLoader.LOAD, pc, inj, [].concat(LOAD_ARRAY));
			test1.addEventListener(TestResultsEvent.RESULTS, handleTest1Results);
			test1.run();
		}

		private function handleTest1Results(e:TestResultsEvent):void
		{
			trace('load test passed: '+e.testResultsO.passed);
			(e.target as TestLoader).removeEventListener(TestResultsEvent.RESULTS, handleTest1Results);
			runTest2();
		}

		private function runTest2():void
		{
			var test2:TestLoader = new TestLoader(TestLoader.UNLOAD, pc, inj, [].concat(LOAD_ARRAY));
			test2.addEventListener(TestResultsEvent.RESULTS, handleTest2Results);
			test2.run();
		}

		private function handleTest2Results(e:TestResultsEvent):void
		{
			trace('unload test passed: '+e.testResultsO.passed);
			(e.target as TestLoader).removeEventListener(TestResultsEvent.RESULTS, handleTest2Results);
		}

	}
}

