import { AnswerStatus } from '../enums/AnswerStatus'
import { PracticeStatus } from "../enums/PracticeStates"
import { getRandomQuestions, Question } from "../model/Question"
import { promptAction } from '@kit.ArkUI'
import OptionButton from "../components/OptionButton"
import StatItem from "../components/StatItem"
import ResultDialog from "../components/ResultDialog"


@Component
export  default  struct Practice {
  // 初始状态是停止状态
  @State practiceStatus: PracticeStatus = PracticeStatus.Stopped
  // 当前题目数量
  @State totalCount: number = 10
  // 定义列表  随机获取10个题目
  @State questions: Question[] = getRandomQuestions(this.totalCount)
  // 索引
  @State currentIndex: number = 0
  // 是否可以按下按钮
  @State answerStatus: AnswerStatus = AnswerStatus.Answering
  // 选中的选项
  @State selectOption: string = ''
  // 当前进度
  @State answeredCount: number = 0
  // 当前答对题目数量
  @State rightCount: number = 0

  @StorageLink('currentTabIndex') currentTabIndex: number = 0
  // 创建计时器实例
  timerController: TextTimerController = new TextTimerController()
  // 计时器时间
  timeUsed: number = 0
  // 开始注册自定义弹窗
  dialogController: CustomDialogController = new CustomDialogController(
    {
      builder: ResultDialog({
        answeredCount: this.answeredCount,
        rightCount: this.rightCount,
        timeUsed: this.timeUsed,

        restPractice: () => {
          //   重置题目
          this.questions = getRandomQuestions(this.totalCount)

          //   重置当前进度index
          this.currentIndex = 0
          //   重置当前题目进度
          this.answeredCount = 0
          //   重置当前答对题目
          this.rightCount = 0
          //   计时器
          this.timeUsed = 0
          //   关闭定时器
          this.timerController.reset()
          // 重置状态
          this.answerStatus = AnswerStatus.Answering

        },
        startPractice: () => {
          this.startPractice()
        },
        punch:()=>{
          this.currentTabIndex = 1
        }
      }),
      customStyle: true
    }
  )

  // 开始测试
  startPractice() {
    this.practiceStatus = PracticeStatus.Running
    //   启动计时器
    this.timerController.start()
  }

  pausePractice() {
    this.practiceStatus = PracticeStatus.Paused
    //   暂停计时器
    this.timerController.pause()
  }

  stopPractice() {
    this.practiceStatus = PracticeStatus.Stopped
    //   停止计时器
    this.timerController.pause()
    //   弹窗
    this.dialogController.open()
  }

  build() {
    Column() {
      //   todo同级面板
      Column({
        space: 10
      }) {
        StatItem({
          icon: $r('app.media.ic_accuracy'),
          name: '准确率',
          fontColor: Color.Black
        }) {
          Text(this.answeredCount === 0 ? '0%' : (this.rightCount / this.answeredCount * 100).toFixed() + '%')
            .textAlign(TextAlign.Center)
            .width(100)
        }


        //   进度
        StatItem({
          icon: $r('app.media.ic_progress'),
          name: '进度',
          fontColor: Color.Black
        }) {
          Progress({
            value: this.answeredCount,
            total: this.totalCount
          })
            .width(100)
        }

        //   按钮

        StatItem({
          icon: $r('app.media.ic_count'),
          name: '个数',
          fontColor: Color.Black
        }) {
          Button(this.totalCount.toString())
            .width(100)
            .height(25)
            .backgroundColor('#EBEBEB')
            .fontColor(Color.Black)
            .enabled(this.practiceStatus === PracticeStatus.Stopped)
            .onClick(() => {
              TextPickerDialog.show({
                range: ['5', '10', '15', '20'],
                value: this.totalCount.toString(),
                onAccept: (result) => {
                  this.totalCount = parseInt(result.value as string)
                  //   重新获取最新题库
                  this.questions = getRandomQuestions(this.totalCount)

                  //   并且全部的计数状态清空

                  this.answeredCount = 0
                  this.rightCount = 0
                  //   并且定时器清空
                  this.timerController.reset()
                },
                alignment: DialogAlignment.Bottom
              })
            })
        }

        //   进度
        StatItem({
          icon: $r('app.media.ic_timer'),
          name: '用时',
          fontColor: Color.Black
        }) {
          Row() {
            TextTimer({
              controller: this.timerController
            })
              .onTimer((utc, elapsedTime) => {
                this.timeUsed = elapsedTime

              })
          }
          .width(100)
          .justifyContent(FlexAlign.Center)

        }

      }.statBgStyle()

      //   题目
      Column() {
        Text(this.questions[this.currentIndex].word)
          .wordStyle()
        Text(this.questions[this.currentIndex].sentence)
          .sentenceStyle()
      }

      //   选项按钮
      Column({
        space: 10
      }) {
        ForEach(this.questions[this.currentIndex].options, (option: string) => {
          OptionButton({
            option,
            answerStatus: this.answerStatus,
            answer: this.questions[this.currentIndex].answer,
            selectOption: this.selectOption
          })
            .enabled(this.answerStatus === AnswerStatus.Answering)
            .onClick(() => {
              // 判断联系状态
              if (this.practiceStatus !== PracticeStatus.Running) {

                promptAction.showToast({
                  message: '请先点击开始测试',
                  alignment: Alignment.Center
                })

                return
              }

              // todo 判断对错
              this.selectOption = option

              // todo 更新统计信息

              this.answeredCount++
              if (option === this.questions[this.currentIndex].answer) {
                this.rightCount++
              }

              // 先更改状态
              this.answerStatus = AnswerStatus.Answered

              if (this.currentIndex < this.questions.length - 1) {
                setTimeout(() => {
                  this.currentIndex++
                  this.answerStatus = AnswerStatus.Answering
                }, 500)
              } else {
                this.stopPractice()
              }
            })
        }

        )
      }

      //   控制按钮
      Row({
        space: 50
      }) {
        Button('停止测试')
          .controlButtonStyle({
            bg: Color.Transparent,
            border: this.practiceStatus === PracticeStatus.Stopped ? Color.Gray : Color.Black,
            font: this.practiceStatus === PracticeStatus.Stopped ? Color.Gray : Color.Black
          })
          .enabled(this.practiceStatus !== PracticeStatus.Stopped)
          .onClick(() => {

            this.stopPractice()
          })

        Button(this.practiceStatus === PracticeStatus.Running ? '暂停测试' : '开始测试').controlButtonStyle({
          bg: Color.Black,
          border: this.practiceStatus === PracticeStatus.Running ? '#555555' : Color.Black,
          font: this.practiceStatus === PracticeStatus.Running ? '#555555' : Color.White
        })
          .stateEffect(false)
          .onClick(() => {
            if (this.practiceStatus === PracticeStatus.Running) {
              //   暂停测试
              this.pausePractice()
            } else {
              //   开始测试
              this.startPractice()
            }
          })
      }

    }
    .practiceBgStyle()

  }
}


//定义一个集成Column的结构
@Extend(Column)
function practiceBgStyle() {
  .height('100%')
  .width('100%')
  .backgroundImage($r('app.media.img_practice_bg'))
  .backgroundImageSize(ImageSize.Cover)
  .justifyContent(FlexAlign.SpaceEvenly)
}

//通用样式
@Styles
function statBgStyle() {
  .backgroundColor(Color.White)
  .width('90%')
  .borderRadius(10)
  .padding(10)
}

@Extend(Text)
function wordStyle() {
  .fontSize(50)
  .fontWeight(FontWeight.Bold)
}

@Extend(Text)
function sentenceStyle() {
  .height(40)
  .fontSize(16)
  .fontColor('#9BA1A5')
  .width('80%')
  .textAlign(TextAlign.Center)
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