//
//  Header.h
//  Enjoy Music
//
//  Created by qianfeng on 16/4/5.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#ifndef Header_h
#define Header_h

// 首页
#define BASE_URL @"http://mapi.yinyuetai.com/suggestions/front_page.json?"
// 首页详情
#define FIRST_URL @"deviceinfo=%7B%22aid%22%3A%2210201022%22%2C%22os%22%3A%22Android%22%2C%22ov%22%3A%224.1.2%22%2C%22rn%22%3A%22480*800%22%2C%22dn%22%3A%22Jiayu%20G2H%22%2C%22cr%22%3A%2246002%22%2C%22as%22%3A%22WIFI%22%2C%22uid%22%3A%226c9d15f9e4fead03f9bfe8c9f3a14735%22%2C%22clid%22%3A110004000%7D&size=20"

//首页详情(参数id)
#define FIRST_DETAIL @"http://mapi.yinyuetai.com/playlist/show.json?deviceinfo=%7B%22aid%22%3A%2210201022%22%2C%22os%22%3A%22Android%22%2C%22ov%22%3A%224.1.2%22%2C%22rn%22%3A%22480*800%22%2C%22dn%22%3A%22Jiayu%20G2H%22%2C%22cr%22%3A%2246002%22%2C%22as%22%3A%22WIFI%22%2C%22uid%22%3A%226c9d15f9e4fead03f9bfe8c9f3a14735%22%2C%22clid%22%3A110004000%7D"


#define URL(_r) [BASE_URL stringByAppendingString:_r]

// 首播scrollView的详情
#define FIRST_SCROLL @"http://mapi.yinyuetai.com/video/get_mv_areas.json?deviceinfo=%7B%22aid%22%3A%2210201022%22%2C%22os%22%3A%22Android%22%2C%22ov%22%3A%224.1.2%22%2C%22rn%22%3A%22480*800%22%2C%22dn%22%3A%22Jiayu%20G2H%22%2C%22cr%22%3A%2246002%22%2C%22as%22%3A%22WIFI%22%2C%22uid%22%3A%226c9d15f9e4fead03f9bfe8c9f3a14735%22%2C%22clid%22%3A110004000%7D"

//MV首播 的网址 有日期  和area  eg:日本
#define  SHOUBO @"http://mapi.yinyuetai.com/video/list.json?deviceinfo=%7B%22aid%22%3A%2210201022%22%2C%22os%22%3A%22Android%22%2C%22ov%22%3A%224.1.2%22%2C%22rn%22%3A%22480*800%22%2C%22dn%22%3A%22Jiayu%20G2H%22%2C%22cr%22%3A%2246002%22%2C%22as%22%3A%22WIFI%22%2C%22uid%22%3A%226c9d15f9e4fead03f9bfe8c9f3a14735%22%2C%22clid%22%3A110004000%7D&size=20"
//韩国（正在流行）
#define POPULAR @"http://mapi.yinyuetai.com/video/list.json?deviceinfo=%7B%22aid%22%3A%2210201022%22%2C%22os%22%3A%22Android%22%2C%22ov%22%3A%224.1.2%22%2C%22rn%22%3A%22480*800%22%2C%22dn%22%3A%22Jiayu%20G2H%22%2C%22cr%22%3A%2246002%22%2C%22as%22%3A%22WIFI%22%2C%22uid%22%3A%226c9d15f9e4fead03f9bfe8c9f3a14735%22%2C%22clid%22%3A110004000%7D&size=20"
//MV首页(scrollView)
#define MVSBSCROLL @"http://mapi.yinyuetai.com/video/get_mv_areas.json?deviceinfo=%7B%22aid%22%3A%2210201022%22%2C%22os%22%3A%22Android%22%2C%22ov%22%3A%224.1.2%22%2C%22rn%22%3A%22480*800%22%2C%22dn%22%3A%22Jiayu%20G2H%22%2C%22cr%22%3A%2246002%22%2C%22as%22%3A%22WIFI%22%2C%22uid%22%3A%226c9d15f9e4fead03f9bfe8c9f3a14735%22%2C%22clid%22%3A110004000%7D"

#endif /* Header_h */
