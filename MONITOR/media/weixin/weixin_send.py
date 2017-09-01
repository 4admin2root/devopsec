#!/usr/bin/python
# coding: utf-8
import urllib,urllib2
import json
import sys
reload(sys)
sys.setdefaultencoding('utf8')
def gettoken():
    CropID='wwdae'
    Secret='VA4jLOi7E'
    URL="https://qyapi.weixin.qq.com/cgi-bin/gettoken?corpid="+CropID+"&corpsecret="+Secret
    token_file = urllib2.urlopen(URL)
    token_data = token_file.read().decode('utf-8')
    token_json = json.loads(token_data)
    token_json.keys()
    return token_json['access_token']
def sendmsg(access_token,username,content):
    URL="https://qyapi.weixin.qq.com/cgi-bin/message/send?access_token="+access_token
    send_values = {
        "touser":username,
        "msgtype":"text",
        "agentid":1000024,
        "text":{
            "content":content
           }
        }
    send_data = json.dumps(send_values, ensure_ascii=False)
    send_request = urllib2.Request(URL, send_data)
    urllib2.urlopen(send_request)

if __name__ == '__main__':
    username = str(sys.argv[1])
    content = str(sys.argv[3])
    f = open('/tmp/weixin.log','a')
    f.write(str(sys.argv[1:]))
    f.close()
    accesstoken = gettoken()
    sendmsg(accesstoken,username,content)
