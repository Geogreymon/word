import StatItem from "../components/StatItem"
import { createPost } from '../http/Api'
import { convertMillisecondsToTime } from "../utils/DateUtil"
import { promptAction, router } from '@kit.ArkUI'
import { emitter } from '@kit.BasicServicesKit'

@CustomDialog
@Component
export default struct ResultDialog {
  // 定义状态
  answeredCount: number = 0
  rightCount: number = 0
  timeUsed: number = 0
  restPractice: () => void = () => {
  }
  startPractice: () => void = () => {

  }
  punch: () => void = () => {
  }
  // 创建实例
  controller: CustomDialogController = new CustomDialogController(
    {
      builder: ResultDialog()
    }
  )
  // 查看是否有token
  @StorageProp('token') token: string = ''

  build() {
    Column({
      space: 10
    }) {
      Image($r('app.media.ic_close'))
        .width(25)
        .height(25)
        .alignSelf(ItemAlign.End)
        .onClick(() => {
          // 关闭弹窗
          this.controller.close()
          this.restPractice()
        })

      Column({
        space: 10
      }) {
        Image($r('app.media.img_post'))
          .width('100%')
          .borderRadius(10)

        StatItem(
          {
            icon: $r('app.media.ic_timer'),
            name: '超时',
            fontColor: Color.Black
          }
        ) {
          Text(convertMillisecondsToTime(this.timeUsed))
        }

        StatItem(
          {
            icon: $r('app.media.ic_accuracy'),
            name: '准确率',
            fontColor: Color.Black
          }
        ) {
          Text(this.answeredCount === 0 ? '0%' : (this.rightCount / this.answeredCount * 100).toFixed() + '%')
        }

        StatItem(
          {
            icon: $r('app.media.ic_count'),
            name: '个数',
            fontColor: Color.Black
          }
        ) {
          Text(this.rightCount.toString())
        }

        // 分割线
        Divider()

        Row({
          space: 30
        }) {
          Button('再来一次')
            .controlButtonStyle({
              bg: Color.Transparent,
              border: Color.Black,
              font: Color.Black
            })
            .onClick(() => {
              this.controller.close()
              this.restPractice()
              this.startPractice()
            })

          Button(this.token ? '立即打卡' : '登录打卡')
            .controlButtonStyle({
              bg: Color.Black,
              border: Color.Black,
              font: Color.White
            })
            .onClick(async () => {
              //   登陆并打卡
              this.controller.close()
              this.restPractice()

              if (this.token) {
                //   todo:发送打卡请求
                //   todo:跳转到打卡页
                await createPost({
                  rightCount: this.rightCount,
                  answeredCount: this.answeredCount,
                  timeUsed: this.timeUsed
                })
                promptAction.showToast({ message: '打卡成功' })

                // 通知页面刷新
                emitter.emit({
                  eventId:1 , // 任务id
                })
                //   跳转打卡页
                this.punch()

              } else {
                //   跳转登陆页面
                router.pushUrl({
                  url: 'pages/LoginPage', params: {
                    // 切换页面，也可以返回，路由时传递必要的参数
                    rightCount: this.rightCount,
                    answeredCount: this.answeredCount,
                    timeUsed: this.timeUsed
                  }
                })
              }
            })

        }

      }
      .width('100%')
      .backgroundColor(Color.White)
      .padding(20)
      .borderRadius(10)

    }
    .backgroundColor(Color.Transparent)
    .width('80%')

  }
}


interface ControlColor {
  bg: ResourceColor,
  border: ResourceColor,
  font: ResourceColor
}

//页面底部按钮
@Extend(Button)
function controlButtonStyle(color: ControlColor) {
  .fontSize(16)
  .borderWidth(1)
  .backgroundColor(color.bg)
  .borderColor(color.border)
  .fontColor(color.font)

}