import Logger from './Logger';
export class MathUtils {
  static percentageCalculator (start:number,end:number,value:number):number {
    let endTemp = end - start;
    let valueTemp = value - start;



    if(valueTemp>endTemp) {
      return 1;
    } else if(valueTemp<0) {
      return 0;
    }

    let result:number = valueTemp/endTemp;
    return result;
  }
}