import { request } from "./Axios"

import  {postData} from "../model/PostInfo"

interface loginInfo{
  phone:string,
  code:string
}

interface AxiosResponse<T> {
  data: T;
  status: number;
  statusText: string;
  // 其他可能需要的属性...
}


interface AllPost{
  page:number,
  size:number,
  total:number,
  records:postData[]
}

export  interface  useInfoData{
  nickname?:string,
  avatarUrl?:string
}

//获取验证码
export function sendCode(phone: string):Promise<AxiosResponse<string>> {
  return request.get('/word/user/code', {
    params: {
      phone
    }
  })

}

//登陆
export function login(phone: string, code: string):Promise<AxiosResponse<string>> {
  const data :loginInfo={
    phone,
    code
  }
  return request.post('/word/user/login',
    data
  );
}

export  interface postInfo{
  rightCount: number,
  answeredCount: number,
  timeUsed: number
}

// 打卡
export function createPost(post:postInfo):Promise<AxiosResponse<string>>  {
  return request.post('/word/post/create', post)
}


//获取全部打卡列表
export function getAllPost(page: number, size: number):Promise<AxiosResponse<AllPost>> {
  return request.get('/word/post/getAll', { params: { page, size } })
}

//点赞
export function like(postId: number) {
  return request.get('/word/like/create', { params: { postId } })
}

//取消点赞
export function cancelLike(postId: number) {
  return request.get('/word/like/cancel', { params: { postId } })
}


//获取登录用户信息
export function info():Promise<AxiosResponse<useInfoData>>  {
  return request.get('/word/user/info')
}

//获取我的登录打卡记录
export function getMyPost(page: number, size: number):Promise<AxiosResponse<AllPost>> {
  return request.get('/word/post/getMine', { params: { page: page, size: size } })
}