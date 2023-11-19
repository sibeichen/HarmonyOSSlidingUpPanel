/*
 * Copyright (C) 2022 Huawei Device Co., Ltd.
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
import { SlidingUpPanelConfigurator } from './SlidingUpPanelConfigurator';
import { SlidingUpPanelState } from './SlidingUpPanelState';


// const FAST_SLID_TIME = 200; //快速滑动判定时间 200ms
// const SLID_ANIMATION_DURATION = 200; //自动滑动时候执行的滑动动画时间
@Component
export struct  SlidingUpPanel {
  configurator?: SlidingUpPanelConfigurator;
  @State private mHeight:number = 0;
  private startOffsetY:number = 0; //记录手势开始的y偏移量
  private startSlideTime:number;   //开始滑动时间
  private animationDuration:number = 0;
  @Prop private isMove:boolean;  //如果是列表是否置顶，置顶的话才可以向下拉动上层面板布局
  @State positionOffsetY:number = 0  //滑动布局实时变化坐标 屏幕左上角为x:0 y:0
  @BuilderParam bottomLayout?: (() => void) | null = null;
  @BuilderParam upLayout?:(() => void) | null = null;
  stateCallback?:((state:SlidingUpPanelState) => void) | null = null;
  slidOffsetYCallback?:((offsetY:number) => void) | null = null;
  private panelPositionYArray:number[]; //每个固定区域的起始位置
  private  lastPositionOffsetY:number = 0; //滑动布局起始位置
  private checkOffset:number = 100;
  private panOption: PanGestureOptions = new PanGestureOptions({direction:PanDirection.Up| PanDirection.Down})

  layoutState:SlidingUpPanelState = SlidingUpPanelState.MIDDLE;

  aboutToAppear() {
    if(!this.configurator) {
      this.configurator = new SlidingUpPanelConfigurator();
    }
  }
  updateLayoutStateValue(layoutState:SlidingUpPanelState):void{
    this.animationDuration = this.configurator.slidAnimationDuration;
    this.layoutState = layoutState
    if(this.stateCallback !== undefined && this.stateCallback !== null) {
      this.stateCallback(this.layoutState);
    }
    this.positionOffsetY = this.panelPositionYArray[layoutState];
    this.lastPositionOffsetY = this.positionOffsetY;
  }

  build() {
    Stack(){
      //底层布局
      Column() {
        if(this.bottomLayout!== undefined && this.bottomLayout!== null ) {
          this.bottomLayout();
        } else {
          Column() {
            Text("bottomLayout")
          }.height("100%").width("100%")
        }
      }.backgroundColor(this.configurator.bottomLayoutBackGround)
      //上层布局
      Column(){
        if(this.upLayout!== undefined && this.upLayout!== null ) {
          this.upLayout();
        } else {
          Column() {
            Text("upLayout")
          }.height("100%").width("100%")
        }
      }.height(this.mHeight).width("100%")
      .onAreaChange((oldValue: Area, newValue: Area) => {
        if( this.slidOffsetYCallback !== undefined && this.slidOffsetYCallback !== null) {
          this.slidOffsetYCallback(this.positionOffsetY);
        }
      }).position({x:0,y:this.positionOffsetY})
      .backgroundColor(this.configurator.upLayoutBackGround)
      .animation({
        duration:this.animationDuration,
        curve:Curve.FastOutSlowIn,
        delay:0,
        iterations:1,
        playMode:PlayMode.Normal
      }).parallelGesture(
        PanGesture(this.panOption)
          .onActionStart((event?:GestureEvent)=>{
            if(!this.isMove) return;
            this.animationDuration = 0;
            this.startSlideTime = Date.now();
            this.startOffsetY = event.offsetY;
          }).onActionUpdate((event?:GestureEvent)=>{
          if(!this.isMove) return;

          let positionOffsetYTemp:number =  this.lastPositionOffsetY + (this.startOffsetY + event.offsetY);
          //边界处理
          if(positionOffsetYTemp>this.panelPositionYArray[SlidingUpPanelState.BOTTOM]){
            positionOffsetYTemp = this.panelPositionYArray[SlidingUpPanelState.BOTTOM];
          } else if (positionOffsetYTemp<this.panelPositionYArray[SlidingUpPanelState.TOP]) {
            positionOffsetYTemp = this.panelPositionYArray[SlidingUpPanelState.TOP];
          }
          this.positionOffsetY = positionOffsetYTemp;

        }).onActionEnd((event?:GestureEvent)=>{
          if(!this.isMove) return;
          this.lastPositionOffsetY =  this.positionOffsetY;
          let endSlideTime = Date.now();
          if(endSlideTime - this.startSlideTime < this.configurator.fastSlidTime) {  //检测200ms以内判定为快速滑动
            this.animationDuration =  this.configurator.slidAnimationDuration;
            if(this.startOffsetY > 0  ) {
              if(this.layoutState == SlidingUpPanelState.TOP) {
                this.updateLayoutStateValue(SlidingUpPanelState.MIDDLE);
              } else  if(this.layoutState ==SlidingUpPanelState.MIDDLE) {
                this.updateLayoutStateValue(SlidingUpPanelState.BOTTOM);
              }
            } else {
              if(this.layoutState == SlidingUpPanelState.BOTTOM) {
                this.updateLayoutStateValue(SlidingUpPanelState.MIDDLE);
              } else  if(this.layoutState == SlidingUpPanelState.MIDDLE) {
                this.updateLayoutStateValue(SlidingUpPanelState.TOP);
              }
            }
            this.startSlideTime = endSlideTime;
          } else {

            if(this.positionOffsetY<this.panelPositionYArray[SlidingUpPanelState.MIDDLE]-this.checkOffset) {
              this.updateLayoutStateValue(SlidingUpPanelState.TOP);
            }else if(this.positionOffsetY<this.panelPositionYArray[SlidingUpPanelState.MIDDLE]+this.checkOffset) {
              this.updateLayoutStateValue(SlidingUpPanelState.MIDDLE);
            } else {
              this.updateLayoutStateValue(SlidingUpPanelState.BOTTOM);
            }
          }
          this.startOffsetY = 0;
        })
      )

    }.layoutWeight(1).onAreaChange((oldValue: Area, newValue: Area) =>{
      this.mHeight = newValue.height as number;
      this.panelPositionYArray = [this.mHeight*this.configurator.panelPositionYWeightArray[0],
        this.mHeight*this.configurator.panelPositionYWeightArray[1],
        this.mHeight*this.configurator.panelPositionYWeightArray[2]];
      this.updateLayoutStateValue(this.configurator.initState);
      this.checkOffset = this.mHeight/8;

    })
  }
}