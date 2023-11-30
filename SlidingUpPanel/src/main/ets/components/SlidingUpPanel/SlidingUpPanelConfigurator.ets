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
import { SlidingUpPanelState } from './SlidingUpPanelState';

export class SlidingUpPanelConfigurator {

   panelPositionYWeightArray:number[] = [0,0.3,0.8]; //对应的top middle bottom的起始坐标的占比，0为最顶部
   fastSlidTime:number = 200; //快速滑动判定时间 200ms
   slidAnimationDuration:number = 200; //自动滑动时候执行的滑动动画时间
  initState:SlidingUpPanelState = SlidingUpPanelState.MIDDLE; //初始状态
  bottomLayoutBackGround:ResourceColor = "#FFFFFF";  //底层的背景色
  upLayoutBackGround:ResourceColor = "#bbbbbb"; //上层的背景色

  setPanelPositionYWeightArray(panelPositionYWeightArray:number[]):void{
    this.panelPositionYWeightArray = panelPositionYWeightArray;
  }
}