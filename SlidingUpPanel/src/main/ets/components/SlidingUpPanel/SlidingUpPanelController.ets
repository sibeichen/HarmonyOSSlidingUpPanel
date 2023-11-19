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

}