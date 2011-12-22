/**
 * @author cStuempges, percentjuice.com.
 * This software is provided 'as-is', without any express or implied
 * warranty.  In no event will the authors be held liable for any damages
 * arising from the use of this software.
 * Permission is granted to anyone to use this software for any purpose,
 * including commercial applications, and to alter it and redistribute it
 * freely, subject to the following restrictions:
 * 1. The origin of this software must not be misrepresented; you must not
 * claim that you wrote the original software. If you use this software
 * in a product, an acknowledgment in the product documentation would be
 * appreciated but is not required.
 * 2. Altered source versions must be plainly marked as such, and must not be
 * misrepresented as being the original software.
 * 3. This notice may not be removed or altered from any source distribution.
 *
 * http://www.opensource.org/licenses/mit-license.php
 */
package com.percentjuice.bulkyLegs
{
	import com.percentjuice.bulkyLegs.controller.PrepControllerCommand;
	import com.percentjuice.bulkyLegs.controller.PrepModelCommand;
	import com.percentjuice.bulkyLegs.events.InjectDataEvent;
	import com.percentjuice.bulkyLegs.services.bulkyLegsInterface.IInjectorService;
	import com.percentjuice.bulkyLegs.services.bulkyLegsInterface.InjectorService;

	import flash.display.Sprite;

	import org.robotlegs.base.ContextEvent;
	import org.robotlegs.mvcs.Context;

	/**
	 * coordinates injection for Robotlegs.
	 *
	 * this is also the interface to allow possibly non-Robotlegs apps to interact with
	 * 		bulkyLegs as a module.
	 * said interface methods are accessible via injectorService, referenced externally
	 * 		using the getter below.
	 * listen to injectorService instance for Load complete, Unload complete, and Load progress:
	 * 		injectorInstance.addEventListener(LoadedEvent.LOAD_COMPLETE, handleLoadComplete);
	 * 		injectorInstance.addEventListener(LoadedEvent.UNLOAD_COMPLETE, handleUnloadComplete);
	 * 		injectorInstance.addEventListener(LoadingEvent.REQUEST_LOADING, handleLoadProgress);
	 *
	 * @author C Stuempges
	 */
	public class BulkyLegsContext extends Context
	{
		private var _assetsPath:String;
		private var _injectorService:IInjectorService;
		/**
		 * Initializes app.
		 * @param assetsPath: assetsPath should point to the location of your MAPPINGFILEPATH.
		 */
		public function BulkyLegsContext(assetsPath:String, mappingFile:String)
		{
			super(new Sprite(), false);
			startup();
			this._assetsPath=assetsPath;
			dispatchEvent(new InjectDataEvent(InjectDataEvent.ASSETS_PATH, assetsPath));
			dispatchEvent(new InjectDataEvent(InjectDataEvent.MAPPING_FILE, mappingFile));
		}

		public function get assetsPath():String
		{
			return _assetsPath;
		}

		public function get injectorService():IInjectorService
		{
			if (!_injectorService)
			{
				_injectorService = new InjectorService();
				injector.injectInto(_injectorService);
			}
			return _injectorService;
		}

		override public function startup():void
		{
			commandMap.mapEvent(ContextEvent.STARTUP, PrepModelCommand, ContextEvent, true);
			commandMap.mapEvent(ContextEvent.STARTUP, PrepControllerCommand, ContextEvent, true);
			dispatchEvent(new ContextEvent(ContextEvent.STARTUP));
		}
	}
}

