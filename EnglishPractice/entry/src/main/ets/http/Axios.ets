import axios, { AxiosError, AxiosResponse, InternalAxiosRequestConfig } from "@ohos/axios"
import promptAction from '@ohos.promptAction';

//创建axios实例
export   const request = axios.create({
  baseURL: 'http://192.168.124.1:3000',
  timeout: 1000
})


//添加请求拦截器
request.interceptors.request.use((config: InternalAxiosRequestConfig) => {
  // 通过 AppStorage 获取 token
  const token: string | undefined = AppStorage.Get<string>('token')
  if (token) {
    config.headers['token'] = token
  }
  return config
},
  (error: AxiosError) => {
    promptAction.showToast({
      message: error.message
    })
  }
)

//添加响应拦截器
request.interceptors.response.use((response: AxiosResponse) => {

  if (response.data.code === 200) {
    return response.data
  } else {
    promptAction.showToast({ message: response.data.message })
    return Promise.reject(response.data.message)
  }
},
  (error: AxiosError) => {
    // 若出现异常，则提示异常信息
    promptAction.showToast({ message: error.message })
    return Promise.reject(error);
  }
)