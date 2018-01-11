# 艺龙网酒店评论信息 http://hotel.elong.com/60201140/#review
# 导入第三方扩展包
import requests
import re
import time

# 设置请求头
headers = {
'Accept':'application/json, text/javascript, */*; q=0.01',
'Accept-Encoding':'gzip, deflate',
'Accept-Language':'zh-CN,zh;q=0.9',
'Connection':'keep-alive',
'Cookie':'CookieGuid=3b5c8b0a-fa1b-4b50-a52c-85325fc070f0; s_eVar44=ppzqbaidu; _RF1=116.231.231.25; _RSG=BEKQwWdrU9C6K9g9kwS389; _RDG=28ad1e63adceac29ae027f931c904f5b21; _RGUID=c25ed678-3a69-438b-9203-73ab89a89506; _fid=ja80vq1f-ec76-45c9-a744-1dcf7cb46676; CitySearchHistory=0201%23%E4%B8%8A%E6%B5%B7%23Shanghai%23; SessionGuid=9e59d2b1-f6f2-4826-9604-460e58dc8ff8; Esid=45e95c28-6ec8-497b-9c6c-324b892a5d72; semid=ppzqbaidu; outerFrom=ppzqbaidu; com.eLong.CommonService.OrderFromCookieInfo=Status=1&Orderfromtype=5&Isusefparam=0&Pkid=50793&Parentid=3150&Coefficient=0.0&Makecomefrom=0&Cookiesdays=0&Savecookies=0&Priority=9000; fv=pcweb; s_cc=true; s_visit=1; newjava2=0a47e36d02dffe748810d1bfd6e853e6; JSESSIONID=1B44D51276B3CD0314E3AE5A000E37B0; ShHotel=CityID=0201&CityNameCN=%E4%B8%8A%E6%B5%B7%E5%B8%82&CityName=%E4%B8%8A%E6%B5%B7%E5%B8%82&OutDate=2017-12-03&CityNameEN=shanghai&InDate=2017-12-02; page_time=1511172129843%2C1511172146425%2C1511172151102%2C1511172160095%2C1511247543995%2C1511247550631%2C1511247572540%2C1511247578679%2C1511403789491%2C1511403791193%2C1511403823475%2C1511403832773%2C1511403838780%2C1511404322998%2C1512095204500%2C1512095207705%2C1512095221580%2C1512095236335%2C1512095257740%2C1512095265741%2C1512095326737%2C1512095351491%2C1512095452746; SHBrowseHotel=cn=60201044%2C%2C%2C%2C%2C%2C%3B20201300%2C%2C%2C%2C%2C%2C%3B90970616%2C%2C%2C%2C%2C%2C%3B20201373%2C%2C%2C%2C%2C%2C%3B91924821%2C%2C%2C%2C%2C%2C%3B&; s_sq=elongcom%3D%2526pid%253Dhotel.elong.com%25252F60201044%25252F%2526pidt%253D1%2526oid%253Djavascript%25253Avoid(0)%2526ot%253DA',
'User-Agent':'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3236.0 Safari/537.36'
}

# 循环获取每一页的评论数据
evaluation = []
for i in range(1,196):
    url = 'http://hotel.elong.com/ajax/detail/gethotelreviews?hotelId=60201140&recommendedType=0&pageIndex=%d' %i
    res = requests.get(url, headers = headers).text
    
    # 正则匹配评论和情感
    Content = re.findall('"commentId":\d+,"content":"(.*?)",',res)
    Emotion = re.findall('"recomend":(.*?),',res)
    evaluation.append(pd.DataFrame({'Content':Content,'Emotion':Emotion}))
    
    # 睡眠3秒
    time.sleep(3)
    
# 数据转换为数据框    
evaluation_data = pd.concat(evaluation)

# 数据导出
evaluation_data2.to_excel('Hotel Evaluation2.xlsx', index = False)