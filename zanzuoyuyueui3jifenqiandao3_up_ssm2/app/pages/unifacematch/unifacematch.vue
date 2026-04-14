<template>
  <view>
    <u-navbar leftIconSize="0" title="人脸对比" :border="true" :placeholder="true" :autoBack="false"></u-navbar>
    <scroll-view :enable-flex="true" class="svcontainer">

    </scroll-view>
  </view>
</template>

<script>
import {fileUrl} from 'common/config/api.js'
import {mapState, mapActions} from 'vuex';

export default {
  components: {},
  data() {
    return {
      fileUrl: fileUrl
    };
  },
  onLoad(params) {
    this.faceMatch(this.userInfo.img)
  },
  methods: {
    url2base64(img, cb) {
      let url = this.fileUrl + img
      uni.request({
        url: url,
        method: 'GET',
        responseType: 'arraybuffer',
        success: (res) => {
          const base64 = uni.arrayBufferToBase64(res.data)
          cb && cb(base64)
        },
        fail: (err) => {

        },
      })
    },
    faceMatch(userimg) {
      this.url2base64(userimg, (base641) => {
        let clientId = "06n8khDqmNZLzbHG9k2zGhoC";
        // 官网获取的 Secret Key 更新为你注册的
        let clientSecret = "XVNjMXuDM8R6ZYVTWSaAp8C7sCHl6otz";
        uni.chooseImage({
          count: 1,
          success: (res) => {
            let tempFilePaths = res.tempFilePaths[0]
            uni.getFileSystemManager().readFile({
              filePath: tempFilePaths, //选择图片返回的相对路径
              encoding: 'base64', //编码格式
              success: v => { //成功的回调
                let base64 = v.data // 返回的是没有 'data:image/jpeg;base64,'头的数据, 需要在页面显示图片可自行追加上
                let imagebase64 = JSON.stringify([{"image_type": "BASE64", "image": base64}, {
                  "image_type": "BASE64",
                  "image": base641
                }])
                //let imagebase64 = JSON.stringify(imglist)
                uni.request({
                  method: 'POST',
                  url: 'https://aip.baidubce.com/oauth/2.0/token?grant_type=client_credentials&client_id=' + clientId + '&client_secret=' + clientSecret,
                  success: (result) => {
                    let token = result.data.access_token
                    console.info("token:" + token)
                    uni.request({
                      method: 'post',
                      url: 'https://aip.baidubce.com/rest/2.0/face/v3/match?access_token==' + token,
                      header: {
                        'Content-Type': 'application/json'
                      },
                      data: imagebase64,
                      success: (result) => {
                        console.info("人脸相似度:" + result.data.result.score)
                        getApp().globalData.facematch = result.data.result.score
                        uni.navigateBack()
                      }
                    })
                  }
                })
              }
            })
          }
        })
      })
    },
  },
  computed: {
    ...mapState(['userInfo'])
  },
  watch: {
    rstr: {
      immediate: false,
      deep: true,
      handler(news) {
        this.refresh()
      }
    }
  }
}
</script>

<style lang="scss">

</style>
