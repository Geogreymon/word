import router from '@ohos.router';

console.log(AppStorage.get<string>('token'))

if (!AppStorage.get<string>('token')) {
  // 注册token
  PersistentStorage.persistProp('token', '');

}


AppStorage.setOrCreate('currentTabIndex', 0); // 在 AppStorage 中注册 currentTabIndex

@Entry
@Component
struct SplashPages {
  @State flag: boolean = false

  onPageShow(): void {

    animateTo({
      duration: 1000,
      onFinish: () => {
        setTimeout(() => {
          router.replaceUrl({
            url: 'pages/Index'
          })

        }, 500)
      }
    },
      () => {
        this.flag = !this.flag
      }
    )

  }

  build() {
    Column() {
      if (this.flag) {
        Image($r('app.media.ic_logo'))
          .LogStyle()// 过渡动画
          .transition({
            type: TransitionType.Insert,
            opacity: 0,
            translate: {
              x: -150
            }
          })
        Text("留学助手")
          .titleStyle()
          .transition(
            {
              type: TransitionType.Insert,
              opacity: 0,
              translate: {
                x: 150
              }
            }
          )
      }
      Blank()
      Text("SE Harmony Project")// 最底部
        .footerStyle()

    }
    .bgStyle()

  }
}

@Styles
function bgStyle() {
  .width('100%')
  .height('100%')
  .backgroundImage($r('app.media.img_splash_bg'))
  .backgroundImageSize({ width: '100%', height: '100%' })
}


@Extend(Image)
function LogStyle() {
  .width(90)
  .height(90)
  .margin({
    top: 120
  })
}

@Extend(Text)
function titleStyle() {

  .fontSize(21)
  .fontColor(Color.White)
  .fontWeight(FontWeight.Bold)
  .margin({ top: 15 })
}

@Extend(Text)
function footerStyle() {
  .fontSize(12)
  .fontColor('#546B9D')
  .fontWeight(FontWeight.Bold)
  .margin({ bottom: 30 })
}