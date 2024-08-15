import { OptionStatus } from "../enums/OptionStatus"
import { AnswerStatus } from "../enums/AnswerStatus"

interface Color {
  bg: ResourceColor,
  font: ResourceColor
}



@Component
export default struct OptionButton {
  option: string = ''
  answer: string = ''
  @State optionState: OptionStatus = OptionStatus.Default
  // 渲染优先级 每一次改变的时候就会重新渲染一次 如果selectOption放下面则永远不会走
  // this.option === this.selectOption
  @Prop selectOption: string = ''
  @Prop @Watch('onAnswerStatus') answerStatus: AnswerStatus

  onAnswerStatus() {

    if (this.option === this.answer) {
      this.optionState = OptionStatus.Right
    } else {
      if (this.option === this.selectOption) {
        this.optionState = OptionStatus.wrong
      } else {
        this.optionState = OptionStatus.Default
      }
    }

  }

  // 定义一个函数去获取背景颜色
  getBgColor() {
    switch (this.optionState) {
      case OptionStatus.Right:
        return '#1DBF78'
      case OptionStatus.wrong:
        return '#FA635F'
      default:
        return Color.White
    }

  }

  build() {
    Stack() {
      Button(this.option)
        .optionButtonStyle({
          bg: this.getBgColor(),
          font: this.optionState === OptionStatus.Default ? Color.Black : Color.White
        })
      if (this.optionState === OptionStatus.Right) {
        Image($r('app.media.ic_right'))
          .ImageStyle()
      } else if (this.optionState === OptionStatus.wrong) {
        Image($r('app.media.ic_wrong'))
          .ImageStyle()
      }
    }
    .alignContent(Alignment.Start)

  }
}


//选项按钮
@Extend(Button)
function optionButtonStyle(color: Color) {
  .width(240)
  .height(48)
  .fontSize(16)
  .fontWeight(FontWeight.Bold)
  .borderRadius(8)
  .backgroundColor(color.bg)
  .fontColor(color.font)
}

//图片
@Extend(Image)
function ImageStyle() {
  .width(22)
  .height(22)
  .offset({
    x: 18
  })
}