/*
 * Copyright 2023 sibeichen@petalmail.com
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { SlidingUpPanel } from './SlidingUpPanel'
import { SlidingUpPanelState } from './SlidingUpPanelState';
export class  SlidingUpPanelController {
   private slidingUpPanel:SlidingUpPanel = null;

  attach( slidingUpPanel:SlidingUpPanel) {
    this.slidingUpPanel = slidingUpPanel;
  }

  updateLayoutState(state:SlidingUpPanelState):void{
    if(this.slidingUpPanel) {
      this.slidingUpPanel.updateLayoutState(state);
    }
  }

  setSlideEnable(flag:boolean):void {
    if(this.slidingUpPanel) {
      this.slidingUpPanel.setSlideEnable(flag);
    }
  }

}