@Component
export default struct StatItem {
  // icon图片
  icon: string | Resource = ''
  name: string = ''
  // 插槽
  @BuilderParam statComp: () => void
  fontColor: Color | string = ''

  build() {
    Row({
      space:5
    }) {
      Image(this.icon)
        .height(14)
        .width(14)
      Text(this.name)
        .fontWeight(FontWeight.Medium)
        .fontSize(14)
        .fontColor(this.fontColor)
      //   弹簧组件
      Blank()
      //   插槽
      this.statComp()
    }
    .width('100%')
    .height(30)

  }
}