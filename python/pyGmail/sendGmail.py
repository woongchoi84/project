#! /usr/bin/python3

# ==================================================
# Python Embedded Modules
# ==================================================
import	os
import	smtplib
import	numpy as np
from email.mime.text import MIMEText

# ==================================================
#	Defined Modules
# ==================================================
def sendGmail(email, sub, msg):
	# 세션 생성
	s = smtplib.SMTP('smtp.gmail.com', 587)
	# TLS 보안 시작
	s.starttls()
	# 로그인 인증
	s.login('woongchoi@sookmyung.ac.kr', 'vvuf xhhl uhnv urgt')
	# 보낼 메시지 설정
	msg = MIMEText(msg)
	msg['Subject'] = sub
	# 메일 보내기 (send, receive)
	s.sendmail("woongchoi@sookmyung.ac.kr", email, msg.as_string())
	# 세션 종료
	s.quit()

subject = 'test'
msg = '''


'''
sendGmail('woongchoi@sookmyung.ac.kr', subject, msg)

