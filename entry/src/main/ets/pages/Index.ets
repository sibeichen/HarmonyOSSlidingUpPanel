import { SlidingUpPanelConfigurator, SlidingUpPanel,SlidingUpPanelState,SlidingUpPanelController} from '@ironbrothers/slidinguppanel'
import Logger from '../common/utils/Logger';
import { MathUtils } from '../common/utils/MathUtils';

@Entry
@Component
struct Index {
  // @State isMove: boolean = true;
  @State layoutState: boolean = true;
  @State listItemData:string[] = ["a","b","c","d","e","f","g","h","i","j","k","l","m","aa","bb","cc","dd","ee","ff","gg","hh","ii","jj","kk","ll","mm"]

  slidingUpPanelState:SlidingUpPanelState;
  @State slidOffsetY:number = 0;
  private listScroll:Scroller = new Scroller();
  private configurator :SlidingUpPanelConfigurator;
  private slidingUpPanelController :SlidingUpPanelController = new SlidingUpPanelController();

  aboutToAppear() {
    //滑动面板的初始化参数
    this.configurator = new SlidingUpPanelConfigurator();
    this.configurator.setPanelPositionYWeightArray([0,0.2,0.8])
    this.slidingUpPanelState = this.configurator.initState;
  }

  build() {
   Column(){
     SlidingUpPanel({configurator:this.configurator,controller:this.slidingUpPanelController,
       bottomLayout:()=>{
         //自定义底层布局   @Builder
      this.bottomLayout();
     },upLayout:()=>{
         //自定义上层布局   @Builder
         this.upLayout();
     },stateCallback:(state:SlidingUpPanelState)=>{
         //滑动状态回调
         this.slidingUpPanelState = state;
     },slidOffsetYCallback:(offsetY:number)=>{
         //滑动位移数回调
         Logger.debug(" this.slidOffsetY:"+ this.slidOffsetY);
        this.slidOffsetY = offsetY;
     }
     })
   }
  }


  /**
   * 自定义上层布局
   */
  @Builder
  private upLayout() {
    Row(){
      Image($r("app.media.app_icon")).width(50).height(50)
    }.width("100%").position({y:-25}).justifyContent(FlexAlign.Center).opacity(MathUtils.percentageCalculator(30,110,this.slidOffsetY));
    Column() {

      List({space:2,scroller:this.listScroll}){
        ListItem(){
          Column(){
            Button("点击切换布局状态").onClick(()=>{
              this.listScroll.scrollToIndex(0)
              if(this.slidingUpPanelState===SlidingUpPanelState.MIDDLE) {
                this.slidingUpPanelController.updateLayoutState(SlidingUpPanelState.BOTTOM)
              } else {
                this.slidingUpPanelController.updateLayoutState(SlidingUpPanelState.MIDDLE)
              }
            })
          }.width("100%").height(200).justifyContent(FlexAlign.Center).alignItems(HorizontalAlign.Center)
        }
          ListItemGroup({ header: this.itemHead("header"),space:5}){
        ForEach(this.listItemData,(item,index)=>{
            ListItem() {
              Text(item).fontSize(20).align(Alignment.Center)
            }.backgroundColor("#ffaff1e3").width("100%").height(40)

          },(item)=> item)
        }
      }.edgeEffect(EdgeEffect.None).onScrollFrameBegin((offset: number, state: ScrollState) => {
        return { offsetRemain: this.slidingUpPanelState===SlidingUpPanelState.TOP&&this.slidOffsetY==0 ? offset: -1 };
      }).onTouch((event:TouchEvent)=>{
        if(event.type == TouchType.Move) {
          if(this.listScroll.currentOffset().yOffset<=0.1) {
            this.slidingUpPanelController.setSlideEnable(true);
          } else {
            this.slidingUpPanelController.setSlideEnable(false);
          }
        }
      }).layoutWeight(1).sticky(StickyStyle.Header)
    }.width("100%").height("100%").layoutWeight(1);
  }

  /**
   * 自定义底层布局
   */
  @Builder
  private bottomLayout() {
     Stack(){
       Image($r("app.media.girl_01")).height("100%").width("100%")
       Image($r("app.media.girl_02")).height("100%").width("100%").opacity(MathUtils.percentageCalculator(300,600,this.slidOffsetY))
     }
  }


  @Builder itemHead(text: string) {
    // 列表分组的头部组件，对应联系人分组A、B等位置的组件
    Text(text)
      .fontSize(20)
      .backgroundColor('#fff1f3f5')
      .width('100%')
      .padding(5)
  }
}


