export  interface postData {
  id: number,
  postText: string,
  rightCount: number,
  answeredCount: number,
  timeUsed: number,
  createTime: string,
  likeCount: number,
  nickname: string,
  avatarUrl: string,
  isLike: boolean
}

// 代表要深度监听的类
@Observed
export class PostInfo {
  id: number;
  postText: string;
  rightCount: number;
  answeredCount: number;
  timeUsed: number;
  createTime: string;
  likeCount: number;
  nickname: string;
  avatarUrl: string
  isLike: boolean;

  constructor(post: postData) {
    this.id = post.id;
    this.postText = post.postText;
    this.rightCount = post.rightCount;
    this.answeredCount = post.answeredCount;
    this.timeUsed = post.timeUsed;
    this.createTime = post.createTime;
    this.likeCount = post.likeCount;
    this.nickname = post.nickname;
    this.avatarUrl = post.avatarUrl;
    this.isLike = post.isLike;
  }
}