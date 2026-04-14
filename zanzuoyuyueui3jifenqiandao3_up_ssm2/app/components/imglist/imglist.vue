<template>
	<view>
		<view v-show="showSearch" class="hpaddingctn" style="margin-bottom:10rpx;">
      <view class="searchctn" :style="{'background-color':bgcolor}">
        <u--input style="border: 0;" v-model="searchstr" @input="toggleSearch"
                  :placeholder="searchPlace" prefixIcon="search"
                  prefixIconStyle="font-size: 29px !important;color: #909399" />
      </view>

		</view>

		<block v-if="imgSize==3">
			<block v-for="(item,index) in dataList" :key="item[idName]">
        <view v-show="toggleShow(item.isShow)">
				<view v-if="htitleName" class="htitlestatus" :style="{'background-color':bgcolor}">
					<view @click="fatherFun(item[idName])" class="htitle" :style="{'color': htitleColor}">
						{{htitleLabel}}{{item[htitleName]}}
					</view>
					<view class="hstatus" :style="{'color': hsColor}">
						{{hsLabel}}{{getSimpleText(item[hsName])}}
					</view>
				</view>
				<view @click="fatherFun(item[idName])" v-show="toggleShow(item.isShow)" :style="{'background-color':bgcolor}"
					:class="'list_item3 itemStyle'+sType+''">
          <view style="z-index: 999">
            <view class="titlectn3" :style="{'color': titleColor}">
              {{titleLabel}}{{item[titleName]}}
            </view>
            <view v-if="item[imgName]">
              <image class="blog_cover3" mode="widthFix" :src="fileUrl+item[imgName]"></image>
            </view>
            <view v-if="sName" class="sctn3" :style="{'color': sColor}">
              {{sLabel}}{{getSimpleText(item[sName])}}
            </view>
            <view v-if="tName" class="tctn3" :style="{'color': tColor}">
              {{tLabel}}{{item[tName]}}
            </view>
          </view>

					<view class="opctn2" v-if="oLabel">
						<view class="opitem">
							<u-button size="mini" :plain="true" type="warning" @click="opFunction(item[idName])"
								:text="oLabel"></u-button>
						</view>
					</view>
				</view>
			</view>	
			</block>
		</block>
		<block v-if="imgSize==2">
			<block v-for="(item,index) in dataList" :key="item[idName]">
        		    <view v-show="toggleShow(item.isShow)">
				<view v-if="htitleName" class="htitlestatus" :style="{'background-color':bgcolor}">
					<view @click="fatherFun(item[idName])" class="htitle" :style="{'color': htitleColor}">
						{{htitleLabel}}{{item[htitleName]}}
					</view>
					<view class="hstatus" :style="{'color': hsColor}">
						{{hsLabel}}{{getSimpleText(item[hsName])}}
					</view>
				</view>
				<view v-show="toggleShow(item.isShow)"
					:style="{'flex-direction': (fx?'row-reverse':'row'),'background-color':bgcolor}"
					:class="'list_item2 itemStyle'+sType+' '+ (sshadow ? 'fshadow':'')+''">
					<view @click="fatherFun(item[idName])" class="item_img2" v-if="item[imgName]">
						<image class="blog_cover2" :src="fileUrl+item[imgName]"></image>
					</view>
					<view class="item_txt2">
            <view @click="fatherFun(item[idName])">
              <view  class="titlectn2" :style="{'color': titleColor}">
                {{titleLabel}}{{item[titleName]}}
              </view>
              <view class="sctn2" :style="{'color': sColor}">
                {{sLabel}}{{getSimpleText(item[sName])}}
              </view>
              <view :style="{'color': tColor}" v-if="tName" class="tctn2">
                {{tLabel}}{{item[tName]}}
              </view>
            </view>

						<view class="opctn2" v-if="oLabel">
							<view class="opitem">
								<u-button size="mini" :plain="true" type="warning" @click="opFunction(item[idName])"
									:text="oLabel"></u-button>
							</view>
						</view>
						<view class="opctn2" v-if="cbox">
							<view class="opitem">
								<u-checkbox :name="item[idName]+''" class="imglistcheck"></u-checkbox>
							</view>
						</view>
					</view>

				</view>
			    </view>
			</block>
		</block>




		<block v-if="imgSize=='timuresult'">
			<block v-for="(item,index) in dataList" :key="item[idName]">
				<view v-show="toggleShow(item.isShow)"
					:style="{'flex-direction': (fx?'row-reverse':'row'),'background-color':bgcolor}"
					:class="'list_item2 itemStyle'+sType+''">
					<view @click="fatherFun(item[idName])" class="item_img2" v-if="item[imgName]">
						<image class="blog_cover2" :src="fileUrl+item[imgName]"></image>
					</view>
					<view class="item_txt2">
						<view @click="fatherFun(item[idName])" class="titlectn2" :style="{'color': titleColor}">
							{{titleLabel}}{{item[titleName]}}
						</view>
						<view class="sctn2" :style="{'color': sColor}">
							{{sLabel}}{{getSimpleText(item[sName])}}
						</view>
						<view :style="{'color': item[tName]=='答对'?'green':'red'}" v-if="tName" class="tctn2">
							{{tLabel}}{{item[tName]}}
						</view>
						<view class="opctn2" v-if="oLabel">
							<view class="opitem">
								<u-button size="mini" :plain="true" type="warning" @click="opFunction(item[idName])"
									:text="oLabel"></u-button>
							</view>
						</view>
						<view class="opctn2" v-if="cbox">
							<view class="opitem">
								<u-checkbox :name="item[idName]+''" class="imglistcheck"></u-checkbox>
							</view>
						</view>
					</view>

				</view>
			</block>
		</block>

		<block v-if="imgSize==1">
			<block v-for="(item,index) in dataList" :key="item[idName]">
        <view v-show="toggleShow(item.isShow)">
				<view v-if="htitleName" class="htitlestatus" :style="{'background-color':bgcolor}">
					<view @click="fatherFun(item[idName])" class="htitle" :style="{'color': htitleColor}">
						{{htitleLabel}}{{item[htitleName]}}
					</view>
					<view class="hstatus" :style="{'color': hsColor}">
						{{hsLabel}}{{getSimpleText(item[hsName])}}
					</view>
				</view>
				<view @click="fatherFun(item[idName])" v-show="toggleShow(item.isShow)"
					:style="{'flex-direction': (fx?'row-reverse':'row'),'background-color':bgcolor}"
					:class="'list_item itemStyle'+sType+''">
					<view  class="item_img" v-if="item[imgName]">
						<image class="blog_cover" :style="{'border-radius': round?'50upx':'0'}"
							:src="fileUrl+item[imgName]"></image>
					</view>
					<view class="item_txt">
						<view @click="fatherFun(item[idName])" class="titlectn" :style="{'color': titleColor}">
							{{titleLabel}}{{item[titleName]}}
						</view>

						<view v-if="tName" class="tctn" :style="{'color': tColor}">
							{{tLabel}}{{getSimpleText(item[tName])}}
						</view>
						<view v-if="oLabel" class="opctn2">
							<view class="opitem">
								<u-button size="mini" :plain="true" type="warning" @click="opFunction(item[idName])"
									:text="oLabel"></u-button>
							</view>
						</view>
						<view class="opctn2" v-if="cbox">
							<view class="opitem">
								<u-checkbox :name="item[idName]+''" :checked="item.checked"
									class="imglistcheck"></u-checkbox>
							</view>
						</view>
					</view>
          </view>
				</view>
			</block>
		</block>

		<block v-if="imgSize=='huihua'">
			<block v-for="(item,index) in dataList" :key="item[idName]">
				<view v-show="toggleShow(item.isShow)"
					:style="{'flex-direction': (fx?'row-reverse':'row'),'background-color':bgcolor}"
					:class="'list_item itemStyle'+sType+''">
					<view @click="fatherFun(item[idName])" class="item_img" v-if="item[imgName]">
						<image class="blog_cover" :style="{'border-radius': round?'50upx':'0'}"
							:src="fileUrl+item[imgName]"></image>
					</view>
					<view class="item_txt">
						<view @click="fatherFun(item[idName])" class="titlectn" :style="{'color': titleColor}">
							{{titleLabel}}{{item[titleName]}}
						</view>

						<view v-if="tName" class="tctn" :style="{'color': tColor}">
							{{tLabel}}{{getSimpleText(item[tName])}}
						</view>
						<view v-if="oLabel" class="opctn2">
							<view class="opitem">
								<u-button size="mini" :plain="true" type="warning" @click="opFunction(item[idName])"
									:text="oLabel"></u-button>
							</view>
						</view>
						<view class="opctn2" v-if="cbox">
							<view class="opitem">
								<u-checkbox :name="item[idName]+''" :checked="item.checked"
									class="imglistcheck"></u-checkbox>
							</view>
						</view>
						<view v-if="item.type == 1"
							style="position: absolute;width: 20rpx;height: 20rpx;background-color: red;right: 10rpx;border-radius: 10rpx;">
						</view>
					</view>

				</view>
			</block>
		</block>

		<block v-if="imgSize==10">
			<view :class="'waterfall'+cCount+''">
				<view v-show="toggleShow(item.isShow)" :class="'waterfallitem0 itemStyle'+sType+''"
					v-for="item in dataList">
					<image @click="fatherFun(item[idName])" class="wimg0" v-if="item[imgName]" mode="widthFix"
						:src="fileUrl+item[imgName]"></image>
					<view @click="fatherFun(item[idName])" class="wnote0" :style="{'color': titleColor}">
						{{titleLabel}}{{item[titleName]}}</view>
					<view class="wnote0" :style="{'color': sColor}" v-if="sName">
						{{sLabel}}{{getSimpleText(item[sName])}}</view>
					<view class="wprice0" :style="{'color': tColor}" v-if="tName">{{tLabel}}{{item[tName]}}</view>
					<view class="opctn2" v-if="oLabel">
						<view class="opitem">
							<u-button size="mini" :plain="true" type="warning" @click="opFunction(item[idName])"
								:text="oLabel"></u-button>
						</view>
					</view>
				</view>
			</view>
		</block>

		<block v-if="imgSize==20">
			<view class="u-cell-group">
				<u-cell v-if="item[imgName] && toggleShow(item.isShow)" :icon="fileUrl+item[imgName]"
					@click="fatherFun(item[idName])" v-for="(item,index) in dataList" :key="item[idName]"
					:title="item[titleName]" :value="item[tName]" :label="getSimpleText(item[sName])"
					:isLink="showArrow"></u-cell>
				<u-cell v-if="imgName==='' && toggleShow(item.isShow)" @click="fatherFun(item[idName])"
					v-for="(item,index) in dataList" :key="item[idName]" :title="item[titleName]" :value="item[tName]"
					:label="getSimpleText(item[sName])" :isLink="showArrow"></u-cell>
			</view>
			<!-- <view>
				<uni-list>
					<uni-list-item @click="fatherFun(item[idName])" v-show="toggleShow(item.isShow)" clickable v-for="(item,index) in dataList" :key="item[idName]"
						:title="item[titleName]" :note="getSimpleText(item[sName])" :showArrow="showArrow" :thumb="thumb===null?null:fileUrl+item[thumb]" :thumbSize="thumbSize"
						:rightText="item[rightName]" />
				</uni-list>
			</view> -->
		</block>

		<block v-if="imgSize=='good'">
			<block v-for="(item,index) in dataList" :key="item[idName]">
				<view v-if="htitleName" class="htitlestatus" :style="{'background-color':bgcolor}">
					<view @click="fatherFun(item[idName])" class="htitle" :style="{'color': htitleColor}">
						{{htitleLabel}}{{item[htitleName]}}
					</view>
					<view class="hstatus" :style="{'color': hsColor}">
						{{hsLabel}}{{getSimpleText(item[hsName])}}
					</view>
				</view>
				<view v-show="toggleShow(item.isShow)"
					:style="{'flex-direction': (fx?'row-reverse':'row'),'background-color':bgcolor}"
					:class="'list_item2 itemStyle'+sType+''">
					<view @click="fatherFun(item[idName])" class="item_img2" v-if="item[imgName]">
						<image class="blog_cover2" :src="fileUrl+item[imgName]"></image>
					</view>
					<view class="item_txt2">
						<view @click="fatherFun(item[idName])" class="titlectn2" :style="{'color': titleColor}">
							{{titleLabel}}{{item[titleName]}}
						</view>
						<view class="sctn2" :style="{'color': sColor}">
							{{sLabel}}{{getSimpleText(item[sName])}}
						</view>
						<view :style="{'color': tColor}" v-if="tName" class="tctn2">
							{{tLabel}}{{item[tName]}}
						</view>
						<view class="opctn2" v-if="oLabel">
							<view class="opitem">
								<u-button size="mini" :plain="true" type="warning" @click="opFunction(item[idName])"
									:text="oLabel"></u-button>
							</view>
						</view>

					</view>
				</view>
			</block>
		</block>

		<block v-if="imgSize=='pubu'">
			<view class="waterfall">
				<view v-show="toggleShow(item.isShow)" @click="fatherFun(item[idName])" :class="'waterfallitem itemStyle'+sType+''"
					v-for="item in dataList" :key="item[idName]">
					<image v-if="item[imgName]" class="wimg" mode="widthFix" :src="fileUrl+item[imgName]"></image>
					<text class="wnote">{{titleLabel}}{{item[titleName]}}</text>
					<view class="wuserctn">
						<text v-if="sName" class="wname">{{sLabel}}{{getSimpleText(item[sName])}}</text>
						<text v-if="tName" class="wprice">{{tLabel}}{{item[tName]}}</text>
					</view>
				</view>
			</view>
		</block>
		<block v-if="imgSize=='bloglist'">
			<view v-show="toggleShow(item.isShow)" @click="fatherFun(item.id)" v-for="(item,index) in dataList"
				:key="item.id" :class="'blog_item itemStyle'+sType+''">
				<view class="blog_top">
					<view class="blog_avatar">
						<image class="blogavatar" :src="fileUrl+item.uimg"></image>
					</view>
					<view class="blog_user">
						<text class="busername">{{item.username}}</text>
						<text class="busernote">{{item.ndate}}</text>
					</view>
				</view>
				<view class="blog_note">
					{{item.title}}
				</view>
				<view v-if="item.img">
					<image class="blog_cover" mode="widthFix" :src="fileUrl+item.img"></image>
				</view>
				<view class="blog_op">
					<text>{{item.zan}}赞</text>
				</view>
			</view>
		</block>
	</view>
</template>

<script>
	import {
		fileUrl
	} from '@/common/config/api.js';
	import {
		ideautil
	} from '@/common/commontools.js';
	export default {
		name: "imglist",
		props: {
			dataList: {
				type: Array,
				require: false,
				default: () => []
			},
			clickItem: {
				type: Function,
				default: null
			},
			clickOp: {
				type: Function,
				default: null
			},
			//显示checkbox
			cbox: {
				type: String,
				require: false,
				default: null
			},
			idName: {
				type: String,
				require: false,
				default: 'id'
			},
			titleName: {
				type: String,
				require: false,
				default: 'title'
			},
			titleLabel: {
				type: String,
				require: false,
				default: ''
			},
			titleColor: {
				type: String,
				require: false,
				default: ''
			},
			htitleName: {
				type: String,
				require: false,
				default: null
			},
			htitleLabel: {
				type: String,
				require: false,
				default: ''
			},
			htitleColor: {
				type: String,
				require: false,
				default: '#333'
			},
			searchPlace: {
				type: String,
				require: false,
				default: '请输入关键字'
			},
			sName: {
				type: String,
				require: false,
				default: ''
			},
			sLabel: {
				type: String,
				require: false,
				default: ''
			},
			hsName: {
				type: String,
				require: false,
				default: ''
			},
			hsLabel: {
				type: String,
				require: false,
				default: ''
			},
			sColor: {
				type: String,
				require: false,
				default: ''
			},
			hsColor: {
				type: String,
				require: false,
				default: 'orangered'
			},
			tName: {
				type: String,
				require: false,
				default: ''
			},
			tLabel: {
				type: String,
				require: false,
				default: ''
			},
			tColor: {
				type: String,
				require: false,
				default: ''
			},
			imgName: {
				type: String,
				require: false,
				default: ''
			},
			//图片的位置true在右边
			fx: {
				type: Boolean,
				require: false,
				default: false
			},
			imgSize: {
				type: [Number, String],
				require: false,
				default: 1
			},
			//列表条目显示类型,带阴影样式啥的
			sType: {
				type: [Number, String],
				require: false,
				default: 3
			},
			//瀑布流每行的个数
			cCount: {
				type: [Number, String],
				require: false,
				default: 2
			},
			//缩略图已废弃
			thumb: {
				type: String,
				require: false,
				default: null
			},
			//缩略图已废弃
			thumbSize: {
				type: String,
				require: false,
				default: 'medium'
			},
			showArrow: {
				type: Boolean,
				require: false,
				default: true
			},
			sshadow: {
				type: Boolean,
				require: false,
				default: true
			},
			showSearch: {
				type: Boolean,
				require: false,
				default: true
			},
			oLabel: {
				type: String,
				require: false,
				default: ''
			},
			oColor: {
				type: String,
				require: false,
				default: ''
			},
			round: {
				type: Boolean,
				require: false,
				default: false
			},
			htitlebar: {
				type: Boolean,
				require: false,
				default: false
			},
			bgcolor: {
				type: String,
				require: false,
				default: '#fff !important'
			}
		},
		methods: {
			fatherFun(tid) {
				this.$emit('clickItem', tid)
			},
			opFunction(tid) {
				this.$emit('clickOp', tid)
			},
			getSimpleText: ideautil.getSimpleText,
			toggleShow(ne) {
				if (ne === undefined) {
					return true
				} else {
					return ne
				}

			},
			toggleSearch(e) {
				let fd = uni.itool.FangDou()
				let lis = this.dataList
				if (lis && lis.length) {
					fd(() => {
						for (let i = 0; i < lis.length; i++) {
							console.log(lis[i].isShow)
							lis[i].isShow = true
							this.$set(this.dataList, i, lis[i])
						}
						let searchstr = this.searchstr
						if (searchstr) {
							//lis不是数组,遍历只能获取length属性获取长度然后操作
							for (let i = 0; i < lis.length; i++) {
								let title = lis[i][this.titleName] || '';
								let note = lis[i][this.sName] || '';
								if (title.indexOf(searchstr) != -1 || note.indexOf(searchstr) != -1) {
									lis[i].isShow = true
								} else {
									lis[i].isShow = false
								}
								this.$set(this.dataList, i, lis[i])
							}
						}
					})
				}

			}
		},
		data() {
			return {
				fileUrl: fileUrl,
				searchstr: '',
			};
		}
	}
</script>

<style lang="scss">
@mixin text-ellipsis($lines: 1) {
  display: -webkit-box;
  -webkit-box-orient: vertical;
  -webkit-line-clamp: $lines;
  overflow: hidden;
  text-overflow: ellipsis;
}

/* 通用样式 */
.hpaddingctn {
  padding: 20rpx 30rpx;
}

.searchctn {
  border-radius: 50rpx;
  padding: 15rpx 30rpx;
  @include flex(row);
  align-items: center;
  transition: all 0.3s ease;
}

/* 公共列表项样式 */
.list_item, .list_item2, .list_item3 {
  margin: 20rpx 0;
  padding: 25rpx;
  border-radius: 16rpx;
  transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
  position: relative;
  overflow: hidden;

  &:active {
    transform: scale(0.98);
  }

  &::after {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: rgba(0,0,0,0.02);
    opacity: 0;
    transition: opacity 0.3s;
  }

  &:active::after {
    opacity: 1;
  }
}

/* 图片通用样式 */
.blog_cover, .blog_cover2, .blog_cover3 {
  border-radius: 12rpx;
  transition: transform 0.3s ease;

  &:active {
    transform: scale(0.95);
  }
}

/* 类型1样式（小图列表） */
.list_item {
  @include flex(row);
  align-items: center;

  .item_img {
    width: 120rpx;
    height: 120rpx;
    flex-shrink: 0;
    margin-right: 20rpx;

    image {
      width: 100%;
      height: 100%;
    }
  }

  .item_txt {
    flex: 1;
    min-width: 0;
  }

  .titlectn {
    font-size: 32rpx;
    @include text-ellipsis(1);
    margin-bottom: 8rpx;
  }

  .tctn {
    font-size: 26rpx;
    color: #666;
    @include text-ellipsis(2);
  }
}

/* 类型2样式（中图列表） */
.list_item2 {
  @include flex(row);
  align-items: flex-start;
  .item_img2 {
    width: 220rpx;
    height: 220rpx;
    flex-shrink: 0;
    border-radius: 12rpx;
    overflow: hidden;
    z-index: 999;

    image {
      width: 100%;
      height: 220rpx;
      object-fit: cover;
    }
  }

  .item_txt2 {
    flex: 1;
    margin-left: 25rpx;
    z-index: 999;
  }

  .titlectn2 {
    font-size: 34rpx;
    line-height: 1.4;
    @include text-ellipsis(2);
    margin-bottom: 12rpx;
  }

  .sctn2 {
    font-size: 28rpx;
    color: #666;
    @include text-ellipsis(2);
    margin-bottom: 8rpx;
  }

  .tctn2 {
    font-size: 26rpx;
    color: #e4393c;
    margin-top: 10rpx;
  }
}

/* 类型3样式（大图列表） */
.list_item3 {
  .blog_cover3 {
    width: 100%;
    border-radius: 16rpx;
    margin: 20rpx 0;
  }

  .titlectn3 {
    font-size: 36rpx;
    font-weight: 500;
    line-height: 1.4;
    @include text-ellipsis(2);
    margin-bottom: 15rpx;
  }

  .sctn3 {
    font-size: 28rpx;
    color: #666;
    line-height: 1.6;
    @include text-ellipsis(3);
  }

  .tctn3 {
    font-size: 30rpx;
    color: #e4393c;
    margin: 15rpx 0;
    font-weight: bold;
  }
}

/* 瀑布流布局 */
.waterfall {
  column-count: 2;
  column-gap: 20rpx;
  padding: 0 15rpx;

  .waterfallitem {
    break-inside: avoid;
    margin-bottom: 20rpx;
    background: #fff;
    border-radius: 16rpx;
    overflow: hidden;
    box-shadow: 0 4rpx 20rpx rgba(0,0,0,0.06);
    transition: all 0.3s ease;
    max-height: 400rpx;

    &:active {
      transform: scale(0.98);
    }

    .wimg {
      width: 100%;
      border-radius: 16rpx 16rpx 0 0;
    }

    .wnote {
      display: block;
      padding: 20rpx;
      font-size: 28rpx;
      line-height: 1.4;
    }

    .wuserctn {
      @include flex(row);
      justify-content: space-between;
      padding: 0 20rpx 20rpx;

      .wname {
        font-size: 24rpx;
        color: #666;
      }

      .wprice {
        font-size: 28rpx;
        color: #e4393c;
        font-weight: bold;
      }
    }
  }
}

/* 时间轴样式 */
.timeline-item {
  position: relative;
  padding-left: 40rpx;
  margin-left: 30rpx;

  &::before {
    content: '';
    position: absolute;
    left: 0;
    top: 10rpx;
    width: 16rpx;
    height: 16rpx;
    background: #007aff;
    border-radius: 50%;
  }

  &::after {
    content: '';
    position: absolute;
    left: 7rpx;
    top: 26rpx;
    bottom: -10rpx;
    width: 2rpx;
    background: #ddd;
  }
}

/* 操作按钮容器 */
.opctn2 {
  @include flex(row);
  justify-content: flex-end;
  margin-top: 20rpx;
  z-index: 999;

  .opitem {
    margin-left: 20rpx;

    .u-button {
      box-shadow: 0 4rpx 12rpx rgba(255,153,0,0.2);
      transition: all 0.2s ease;

      &:active {
        transform: scale(0.95);
      }
    }
  }
}

/* 头部状态栏 */
.htitlestatus {
  @include flex(row);
  justify-content: space-between;
  align-items: center;
  padding: 20rpx 25rpx;
  margin: 20rpx 0;
  border-radius: 12rpx;

  .htitle {
    font-size: 32rpx;
    font-weight: bold;

  }

  .hstatus {
    font-size: 26rpx;
    padding: 8rpx 20rpx;
    border-radius: 30rpx;
    background: rgba(255,76,76,0.1);
  }
}

/* 加载动画 */
@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(20rpx);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.list_item, .list_item2, .list_item3 {
  animation: fadeInUp 0.5s ease both;
}

/* 阴影效果 */
.fshadow {
  box-shadow: 0 8rpx 30rpx rgba(0,0,0,0.08);
}

/* 单元格样式 */
.u-cell-group {
  margin: 20rpx 0;

  .u-cell {
    transition: all 0.2s ease;

    &:active {
      background-color: #f8f8f8;
    }
  }
}

/* 博客列表样式 */
.blog_item {
  margin: 25rpx;
  padding: 25rpx;
  background: #fff;
  border-radius: 16rpx;

  .blog_top {
    @include flex(row);
    align-items: center;
    margin-bottom: 20rpx;

    .blogavatar{
      width: 80rpx;
      height: 80rpx;
    }

    .blog_avatar {
      width: 80rpx;
      height: 80rpx;
      border-radius: 50%;
      overflow: hidden;
      margin-right: 20rpx;
    }

    .blog_user {
      flex: 1;

      .busername {
        display: block;
        font-size: 30rpx;
        font-weight: bold;
      }

      .busernote {
        font-size: 24rpx;
        color: #666;
      }
    }
  }

  .blog_note {
    font-size: 28rpx;
    line-height: 1.6;
    margin-bottom: 20rpx;
  }

  .blog_op {
    @include flex(row);
    justify-content: flex-end;
    font-size: 24rpx;
    color: #666;
  }
}

/* 响应式处理 */
@media (max-width: 480px) {
  .list_item2 .item_img2 {
    width: 180rpx;
    height: 130rpx;
  }

}
</style>