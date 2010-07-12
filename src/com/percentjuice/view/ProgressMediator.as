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
package com.percentjuice.view
{
	import br.com.stimuli.loading.BulkProgressEvent;
	import com.percentjuice.controller.LoadedEvent;
	import com.percentjuice.model.objects.LoadedObject;
	import org.robotlegs.mvcs.Mediator;
	import flash.utils.Dictionary;

	public class ProgressMediator extends Mediator
	{
		[Inject]
		public var progress:Progress;

		private var progressBar_notLoading:String;

		override public function onRegister():void
		{
			eventMap.mapListener(eventDispatcher, LoadedEvent.LOAD_COMPLETE, onStateLoaded);
			eventMap.mapListener(eventDispatcher, BulkProgressEvent.PROGRESS, onProgressHandler);

			init();
		}

		private function init():void
		{
			progressBar_notLoading = '';
			progress.progressBar.label = '';
		}

		/* displays load progress */	
		private function onProgressHandler(event : BulkProgressEvent) : void
		{
			var loaded:Number = event.weightPercent;
			progress.progressBar.setProgress(loaded, 1);
			if (loaded<1 && loaded>0)
			{
				progress.progressBar.alpha = 1;
				progress.progressBar.label = (loaded*100).toPrecision(2)+'%';
			}
			else
			{
				progress.progressBar.alpha = .1;
				progress.progressBar.label = progressBar_notLoading;
			}
		}

		/* handles newly loaded asset group */
		private function onStateLoaded(event:LoadedEvent):void
		{
			/* utilize data loaded */
			switch (event.loadedObject.type)
			{
				/* page text */
				case LoadedObject.LANGUAGE:
					eventMap.unmapListener(eventDispatcher, LoadedEvent.LOAD_COMPLETE, onStateLoaded);
					/* this text does not change per language */
					setTextContent(event.loadedObject.loadedRequest);
					break;
				/* loaded groups list */
				case LoadedObject.GROUP:
					break;
			}

		}

		private function setTextContent(languageD:Dictionary):void
		{
			progressBar_notLoading = languageD.l_progressBarDead;
		}


	}
}

