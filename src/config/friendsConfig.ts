import type { FriendLink, FriendsPageConfig } from "../types/config";

// 可以在src/content/spec/friends.md中编写友链页面下方的自定义内容

// 友链页面配置
export const friendsPageConfig: FriendsPageConfig = {
	// 页面标题，如果留空则使用 i18n 中的翻译
	title: "友链",

	// 页面描述文本，如果留空则使用 i18n 中的翻译
	description: "一些朋友们！",

	// 是否显示底部自定义内容（friends.mdx 中的内容）
	showCustomContent: true,

	// 是否开启随机排序配置，如果开启，就会忽略权重，构建时进行一次随机排序
	randomizeSort: false,
};

// 友链配置
export const friendsConfig: FriendLink[] = [
	{
		title: "GeekPie_",
		imgurl: "https://avatars.githubusercontent.com/u/10986330?s=200&v=4",
		desc: "一个秉承开源与合作理念，不断追求思想进步和技术前沿的学生组织。",
		siteurl: "https://geekpie.club",
		tags: ["Assosication"],
		weight: 10, // 权重，数字越大排序越靠前
		enabled: true, // 是否启用
	},
	{
		title: "TUNA",
		imgurl: "https://tuna.moe/assets/img/logo-small-dark@2x.png",
		desc: "欢迎加入 TUNA 协会！",
		siteurl: "https://tuna.moe/",
		tags: ["Assosication"],
		weight: 9, // 权重，数字越大排序越靠前
		enabled: true, // 是否启用
	},
	{
		title: "Astatine Ai",
		imgurl: "https://avatars.githubusercontent.com/u/47201556?v=4",
		desc: "强啊%%%",
		siteurl: "https://github.com/AstatineAi",
		tags: ["GitHub"],
		weight: 5,
		enabled: true,
	},
	{
		title: "Yangyu Chen",
		imgurl: "https://avatars.githubusercontent.com/u/8191303?v=4",
		desc: "期待下次一起写项目！",
		siteurl: "https://blog.cyyself.name/",
		tags: ["Blog"],
		weight: 5,
		enabled: true,
	},
];

// 获取启用的友链并进行排序
export const getEnabledFriends = (): FriendLink[] => {
	const friends = friendsConfig.filter((friend) => friend.enabled);

	if (friendsPageConfig.randomizeSort) {
		return friends.sort(() => Math.random() - 0.5);
	}

	return friends.sort((a, b) => b.weight - a.weight);
};
