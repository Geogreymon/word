import { cancelLike, like } from '../http/Api';
import { PostInfo } from '../model/PostInfo';
import { convertMillisecondsToTime } from '../utils/DateUtil';
import  StatItem from "./StatItem"
@Component
export  default  struct PostItem {
  @ObjectLink post: PostInfo;

  build() {
    Column({ space: 10 }) {
      Row({ space: 10 }) {
        Image(this.post.avatarUrl)
          .height(40)
          .width(40)
          .borderRadius(20)
        Text(this.post.nickname)
          .height(40)
          .fontSize(14)
          .fontWeight(FontWeight.Bold)
        Blank()
        Text(this.post.createTime)
          .height(40)
          .fontSize(14)
          .fontColor('#999999')
          .fontWeight(FontWeight.Medium)
      }.width('100%')

      Text(this.post.postText)
        .width('100%')

      Row() {
        Column() {
          StatItem({
            icon: $r('app.media.ic_timer_white'),
            name: '用时',
            fontColor: Color.White }) {
            Text(convertMillisecondsToTime(this.post.timeUsed))
              .statTextStyle()
          }

          StatItem({
            icon: $r('app.media.ic_accuracy_white'),
            name: '准确率',
            fontColor: Color.White
          }) {
            Text((this.post.answeredCount === 0 ? 0 : this.post.rightCount / this.post.answeredCount * 100).toFixed(0) + '%')
              .statTextStyle()
          }

          StatItem({
            icon: $r('app.media.ic_count_white'),
            name: '个数',
            fontColor: Color.White
          }) {
            Text(this.post.answeredCount.toString())
              .statTextStyle()
          }
        }
        .padding(10)
        .borderRadius(10)
        .layoutWeight(1)
        .backgroundImage($r('app.media.img_post_bg'))
        .backgroundImageSize(ImageSize.Cover)

        Column() {
          Text(this.post.likeCount.toString())
            .fontSize(12)
            .fontWeight(FontWeight.Medium)
            .fontColor(this.post.isLike ? '#3ECBA1' : '#000000')
          Image(this.post.isLike ? $r('app.media.ic_post_like_selected') : $r('app.media.ic_post_like'))
            .width(26)
            .height(26)
            .onClick(() => {
              //todo：点赞/取消点赞
              if(this.post.isLike){
                this.post.isLike=false
                this.post.likeCount--
               cancelLike(this.post.id)

              }else{
                this.post.isLike=true
                this.post.likeCount++
                like(this.post.id)
              }
            })
        }.width(50)
      }.width('100%')
      .alignItems(VerticalAlign.Bottom)
    }
    .padding(10)
    .width('90%')
    .margin({ top: 10 })
    .borderRadius(10)
    .shadow({ radius: 20 })
  }
}

@Extend(Text) function statTextStyle() {
  .width(100)
  .fontSize(16)
  .textAlign(TextAlign.End)
  .fontWeight(FontWeight.Medium)
  .fontColor(Color.White)
}