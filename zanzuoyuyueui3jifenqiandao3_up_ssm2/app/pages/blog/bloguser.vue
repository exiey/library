<template>
	<view>
		<u-navbar title="TA的主页" :border="true" :placeholder="true" :autoBack="true"></u-navbar>
		<scroll-view :enable-flex="true" class="svcontainer">
			<imglist imgName="img" @clickItem="toBlogDetail" :dataList="fobjList" :imgSize="3" titleName="title" sName="note" tName="typecn" ></imglist>
		</scroll-view>
	</view>
</template>

<script>
	import { listSqlj, listj, findj, savej, fileUrl } from '@/common/config/api.js';
	import {mapState, mapActions} from 'vuex';
	import ideaList from '@/components/idea-list/idea-list.vue';
	import blogList from '@/components/blog-list.vue';
	import { ideautil, yewuutil } from '@/common/commontools.js';
	export default {
		data() {
			return {
				fobjList: [],
				typelist: [],
				noticelist: []
			};
		},
		components:{ideaList, blogList},
		onLoad(params) {
			let uid = params.uid;
			listj({params: {table: 'blog',uid:uid }}).then(res => {
				this.fobjList = res
			})
		},
		onShow() {
			
		},
		methods: {
			...mapActions(['updateUserInfo']),
			toBlogDetail:yewuutil.toBlogDetail,
			
			fobjMg(id){
				console.log("------------------>:aid:"+id)
				uni.redirectTo({
					url:'./blogmg?tid='+id
				})
			},
			refreshObj(index){
				let typeid = null
				if(index){
					typeid = index.id==0?null:index.id
				}
				let sql = `select b.*,(select count(pid) from wct_replay r where r.pid=b.id) pinglun,u.img uimg from wct_blog b left join wct_user u on u.id=b.uid where 1=1`
				if (typeid) {
					sql = `select b.*,(select count(pid) from wct_replay r where r.pid=b.id) pinglun,u.img uimg from wct_blog b left join wct_user u on u.id=b.uid where 1=1 and typeid=${typeid}`
				}
				listSqlj({params: {sql: sql}}).then(res => {
					this.fobjList = res
				})
			},
			
			goBack(){
				uni.navigateBack({
					delta:1
				})
			},
			toNotice(){
				uni.navigateTo({
					url:"/pages/notice/notice"
				})
			}
		},
		computed: {
			...mapState(['userInfo'])
		}
	}
</script>

<style lang="scss">

</style>