import  Practice from "../pages/PracticePage"
import  CirclePage from "../pages/CirclePage"
import  MinePage from "../pages/MinePage"

@Entry
@Component
struct Index {
  @StorageLink('currentTabIndex') currentTabIndex:number=0


  build() {
    Tabs(
      {
        index:this.currentTabIndex
      }
    ) {
      TabContent() {
        Practice()
      }.tabBar(
        this.barBuilder(0, '答题', $r('app.media.ic_practice'), $r('app.media.ic_practice_selected'))
      )

      TabContent() {
        CirclePage()
      }.tabBar(this.barBuilder(1, '圈子', $r('app.media.ic_circle'), $r('app.media.ic_circle_selected')))

      TabContent() {
        MinePage()
      }.tabBar(this.barBuilder(2, '我的', $r('app.media.ic_mine'), $r('app.media.ic_mine_selected')))

    }
    .barPosition(BarPosition.End)
    .onChange((index)=>{
      this.currentTabIndex=index
    })
    .width('100%')
  }

  //自定义页面结构
  @Builder barBuilder(index:number,title:string,icon:ResourceStr,iconSelected: Resource){
  Column(){
    Image(this.currentTabIndex === index ?iconSelected:icon)
      .width(25)
      .height(25)
    Text(title)
      .tabTitleStyle(this.currentTabIndex === index ? Color.Black:'#959595')
  }
}
}

@Extend(Text) function  tabTitleStyle(color:ResourceColor){
  .fontSize(10)
  .fontWeight(FontWeight.Bold)
  .fontColor(color)
  .margin({
    bottom:2
  })

}

function CircePage() {
  throw new Error('Function not implemented.')
}
