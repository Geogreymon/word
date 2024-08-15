import { PostInfo, type postData } from '../model/PostInfo'
import { promptAction, router } from '@kit.ArkUI'
import PostItem from "../components/PostItem"
import { getAllPost } from '../http/Api'
import { emitter } from '@kit.BasicServicesKit'

@Component
export default struct CirclePage {
  @State postInfoList: PostInfo[] = []
  // 声明token
  @StorageProp('token') token: string = ''
  @State loading: boolean = false
  page: number = 1
  total: number = 0
  // 滚动条控制器
  scrollController: Scroller = new Scroller()

  async getPostInfoPage() {

    let res = await getAllPost(this.page, 10)

    res.data.records.forEach(
      (post) => {
        this.postInfoList.push(new PostInfo(post))
      }
    )

    this.total = res.data.total
    this.page++


  }

  async refresh() {
    this.loading = true
    this.postInfoList = []
    this.page = 1
    this.total = 0
    await this.getPostInfoPage()
    this.loading = false
  }

  aboutToAppear(): void {
    if (this.token) {
      this.getPostInfoPage()
    } else {
      this.postInfoList = []
      this.total = 0
      this.page = 1
    }

    //   绑定自定义事件
    emitter.on({
      eventId: 1
    }, () => {
      this.refresh()
    })

  }

  build() {
    Column() {
      Text('英语打卡圈')
        .fontSize(18)
        .margin({ top: 45 })
        .fontWeight(FontWeight.Bold)
      Divider()
        .color(Color.Black)
        .margin({ left: 20, right: 20, top: 10 })

      if (this.token) {
        if (this.loading) {
          this.loadingBuilder()


        } else {
          this.listBuilder()
          //todo:打卡列表
        }

      } else {
        this.unLoginBuilder()
        //todo:未登录

      }
    }.height('100%')
    .width('100%')
  }

  // 未登录
  @Builder
  unLoginBuilder() {
    Column({ space: 30 }) {
      Image($r("app.media.ic_unLogin_bg"))
        .width(177)
        .height(177)

      Text('未登录暂无数据')
        .fontSize(14)
        .fontColor('#999999')

      Button('去登录')
        .fontColor(Color.White)
        .fontSize(14)
        .width(100)
        .height(34)
        .backgroundColor('#43C6A0')
        .onClick(() => router.pushUrl({ url: 'pages/LoginPage' }))
    }
    .width('100%')
    .layoutWeight(1)
    .justifyContent(FlexAlign.Center)
  }

  //已登录
  @Builder
  listBuilder() {
    Stack() {
      List(
        {
          scroller: this.scrollController
        }
      ) {
        ForEach(this.postInfoList, (post: PostInfo) => {
          ListItem() {
            PostItem({ post })
          }
        })
      }.width('100%')
      .height('100%')
      .alignListItem(ListItemAlign.Center)
      // 滚动底部事件
      .onReachEnd(() => {

        if (this.postInfoList.length < this.total) {
          this.getPostInfoPage()
        } else {
          promptAction.showToast({
            message: '没有更多数据了'
          })
        }


      })

      Column({ space: 20 }) {
        Button({ type: ButtonType.Circle }) {
          Image($r('app.media.ic_top'))
            .height(14)
            .width(14)
        }
        .height(40)
        .width(40)
        .backgroundColor(Color.Black)
        .opacity(0.5)
        .onClick(() => {
          //todo:返回顶部
          this.scrollController.scrollToIndex(0)
        })

        Button({ type: ButtonType.Circle }) {
          Image($r('app.media.ic_refresh'))
            .height(14)
            .width(14)
        }
        .height(40)
        .width(40)
        .backgroundColor(Color.Black)
        .opacity(0.5)
        .onClick(() => {
          //todo:刷新
          this.refresh()
        })
      }
      .offset({ x: -20, y: -50 })
    }.width('100%')
    .layoutWeight(1)
    .alignContent(Alignment.BottomEnd)
  }

  @Builder
  loadingBuilder() {
    Column({ space: 15 }) {
      Image($r('app.media.ic_loading'))
        .width(30)
        .height(30)
      Text('加载中...')
        .fontSize(16)
        .fontWeight(FontWeight.Medium)
        .fontColor('#7e8892')
    }.width('100%')
    .layoutWeight(1)
    .justifyContent(FlexAlign.Center)
  }
}



