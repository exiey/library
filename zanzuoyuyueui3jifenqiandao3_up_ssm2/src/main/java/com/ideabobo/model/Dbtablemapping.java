package com.ideabobo.model;
import com.alibaba.fastjson.JSON;
public class Dbtablemapping {
	public static Object parseStringModel(String value, String table) {
		Object object = null;
		switch (table) {
			case "wct_address": object = JSON.parseObject(value, Address.class); break;
			case "wct_bill": object = JSON.parseObject(value, Bill.class); break;
			case "wct_blog": object = JSON.parseObject(value, Blog.class); break;
			case "wct_good": object = JSON.parseObject(value, Good.class); break;
			case "wct_notice": object = JSON.parseObject(value, Notice.class); break;
			case "wct_posts": object = JSON.parseObject(value, Posts.class); break;
			case "wct_replay": object = JSON.parseObject(value, Replay.class); break;
			case "wct_room": object = JSON.parseObject(value, Room.class); break;
			case "wct_shiduan": object = JSON.parseObject(value, Shiduan.class); break;
			case "wct_shop": object = JSON.parseObject(value, Shop.class); break;
			case "wct_site": object = JSON.parseObject(value, Site.class); break;
			case "wct_type": object = JSON.parseObject(value, Type.class); break;
			case "wct_type2": object = JSON.parseObject(value, Type2.class); break;
			case "wct_user": object = JSON.parseObject(value, User.class); break;
			case "wct_yuyue": object = JSON.parseObject(value, Yuyue.class); break;
		}
		return object;
}
public static Object getModelByTable(String table) {
	Object object = null;
	switch (table) {
			case "wct_address": object = new Address(); break;
			case "wct_bill": object = new Bill(); break;
			case "wct_blog": object = new Blog(); break;
			case "wct_good": object = new Good(); break;
			case "wct_notice": object = new Notice(); break;
			case "wct_posts": object = new Posts(); break;
			case "wct_replay": object = new Replay(); break;
			case "wct_room": object = new Room(); break;
			case "wct_shiduan": object = new Shiduan(); break;
			case "wct_shop": object = new Shop(); break;
			case "wct_site": object = new Site(); break;
			case "wct_type": object = new Type(); break;
			case "wct_type2": object = new Type2(); break;
			case "wct_user": object = new User(); break;
			case "wct_yuyue": object = new Yuyue(); break;
		}
		return object;
	}
}
