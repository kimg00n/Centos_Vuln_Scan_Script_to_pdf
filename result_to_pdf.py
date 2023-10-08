import markdown
import pdfkit
import matplotlib.pyplot as plt
import subprocess
import base64

def result_to_pdf(result):
    # markdown to html
    html = markdown.markdown(result, extensions=['tables', 'fenced_code'])
    # html to pdf
    pdfkit.from_string(html, 'result.pdf', options={'enable-local-file-access': None})

def get_image_file_as_base64_data():
    with open('./pie.png', 'rb') as image_file:
        return base64.b64encode(image_file.read())

ret = subprocess.check_output('./total.sh', shell=True)
line = ret.splitlines()

good = 0
bad = 0

for i in range(len(line)):
    line[i] = line[i].decode('utf-8')

for i in line[-9:]:
    if "GOOD" in i:
        good += 1
    elif "BAD" in i:
        bad += 1

# pie chart
labels = 'GOOD', 'VULNERABLE'
sizes = [good, bad]
colors = ['lightblue', 'red']
plt.pie(sizes, labels=labels, colors=colors, autopct='%1.1f%%', shadow=True, startangle=140)
plt.axis('equal')
plt.savefig('pie.png')

os_info = subprocess.check_output('cat /etc/os-release', shell=True)
os_info = os_info.splitlines()
os_info = os_info[5]
os_info = os_info[13:-1]

ip_info = subprocess.check_output('ifconfig', shell=True)
ip_info = ip_info.splitlines()
ip_info = ip_info[1]
ip_info = ip_info[8:]

current_path = subprocess.check_output('pwd', shell=True).decode('utf-8').strip()

detail = {"1.Default ID Check": "", 
"2.Root MGM Check": "", 
"3.Passwd File Check": "", 
"4.Group File Check": "", 
"5.Password Rule Check": "", 
"6.Default Shell Check": "", 
"7-1.SU Permission Check(pam.d)": "", 
"7-2.SU Permission Check(wheel)": "", 
"8.Shadow File Check": ""}

for i in line[-9:]:
    if "GOOD" in i:
        if "[1]" in i:
            detail["1.Default ID Check"] = "lp, uucp, nuucp not found\n\n" + subprocess.check_output('cat /etc/passwd', shell=True).decode('utf-8').strip()
        elif "[2]" in i:
            detail["2.Root MGM Check"] = "only root have uid 0\n\n" + subprocess.check_output('awk -F: \'$3==0 { print $1 \" -> UID= \"$3 }\' /etc/passwd', shell=True).decode('utf-8').strip()
        elif "3" in i:
            detail["3.Passwd File Check"] = "passwd file permission is 644\n\n" + subprocess.check_output('ls -al /etc/passwd', shell=True).decode('utf-8').strip()
        elif "4" in i:
            detail["4.Group File Check"] = "group file permission is 644\n\n" + subprocess.check_output('ls -al /etc/group', shell=True).decode('utf-8').strip()
        elif "5" in i:
            detail["5.Password Rule Check"] = line[53:56][0] + "\n" + line[53:56][1] + "\n" + line[53:56][2]
        elif "6" in i:
            detail["6.Default Shell Check"] = "nologin user doesn't have shell\n\n" + subprocess.check_output('cat /etc/passwd | egrep "^daemon|^bin|^sys|^adm|^listen|^nobody|^nobody4|^noaccess|^diag|^operator|^games|^gopher"', shell=True).decode('utf-8').strip()
        elif "[7-1]" in i:
            detail["7-1.SU Permission Check(pam.d)"] = "su command doesn't execute with unauth user\n\n" + subprocess.check_output('cat /etc/pam.d/su', shell=True).decode('utf-8').strip()
        elif "[7-2]" in i:
            detail["7-2.SU Permission Check(wheel)"] = "wheel group user doesn't exist\n\n" + subprocess.check_output('cat /etc/group', shell=True).decode('utf-8').strip()
        elif "8" in i:
            detail["8.Shadow File Check"] = "shadow file permission is Good\n\n" + subprocess.check_output('ls -al /etc/shadow', shell=True).decode('utf-8').strip()
    elif "BAD" in i:
        if "[1]" in i:
            detail["1.Default ID Check"] = "lp, uucp, nuucp founded!!\n\n" + subprocess.check_output('cat /etc/passwd', shell=True).decode('utf-8').strip()
        elif "[2]" in i:
            detail["2.Root MGM Check"] = "uid 0 user founded!!\n\n" + subprocess.check_output('awk -F: \'$3==0 { print $1 \" -> UID= \"$3 }\' /etc/passwd', shell=True).decode('utf-8').strip()
        elif "3" in i:
            detail["3.Passwd File Check"] = "passwd file permission isn't 644!!\n\n" + subprocess.check_output('ls -al /etc/passwd', shell=True).decode('utf-8').strip()
        elif "4" in i:
            detail["4.Group File Check"] = "group file permission isn't 644!!\n\n" + subprocess.check_output('ls -al /etc/group', shell=True).decode('utf-8').strip()
        elif "5" in i:
            detail["5.Password Rule Check"] = line[53:56][0] + "\n" + line[53:56][1] + "\n" + line[53:56][2]
        elif "6" in i:
            detail["6.Default Shell Check"] = "nologin user have shell!!\n\n" + subprocess.check_output('cat /etc/passwd | egrep "^daemon|^bin|^sys|^adm|^listen|^nobody|^nobody4|^noaccess|^diag|^operator|^games|^gopher"', shell=True).decode('utf-8').strip()
        elif "[7-1]" in i:
            detail["7-1.SU Permission Check(pam.d)"] = "su command will execute with unauth user!!\n\n" + subprocess.check_output('cat /etc/pam.d/su', shell=True).decode('utf-8').strip()
        elif "[7-2]" in i:
            detail["7-2.SU Permission Check(wheel)"] = "wheel group user exist!!\n\n" + subprocess.check_output('cat /etc/group', shell=True).decode('utf-8').strip()
        elif "8" in i:
            detail["8.Shadow File Check"] = "shadow file permission is Vulnerable!!\n\n" + subprocess.check_output('ls -al /etc/shadow', shell=True).decode('utf-8').strip()

md = f'''
# Result

## OS info
---
- {os_info.decode('utf-8')}
- {ip_info.decode('utf-8')}

## Summary Chart
---
<img src="{current_path}/pie.png" width="300" height="280">

## Summary Table
---
No                                 | Result
:--------------------------------- | -------------
`1.Default ID Check`               | `{line[-9:][0].split(".")[1]}`
`2.Root MGM Check`                 | `{line[-9:][1].split(".")[1]}`
`3.Passwd File Check`              | `{line[-9:][2].split(".")[1]}`
`4.Group File Check`               | `{line[-9:][3].split(".")[1]}`
`5.Password Rule Check`            | `{line[-9:][4].split(".")[1]}`
`6.Default Shell Check`            | `{line[-9:][5].split(".")[1]}`
`7-1.SU Permission Check(pam.d)`   | `{line[-9:][6].split(".")[1]}`
`7-2.SU Permission Check(wheel)`   | `{line[-9:][7].split(".")[1]}`
`8.Shadow File Check`              | `{line[-9:][8].split(".")[1]}`

## Detail
### {list(detail.keys())[0]}
---
- Result : `{line[-9:][0].split(".")[1]}`
- Detail
```bash
{list(detail.values())[0]}
```

### {list(detail.keys())[1]}
---
- Result : `{line[-9:][2].split(".")[1]}`
- Detail
```bash
{list(detail.values())[1]}
```

### {list(detail.keys())[2]}
---
- Result : `{line[-9:][2].split(".")[1]}`
- Detail
```bash
{list(detail.values())[2]}
```

### {list(detail.keys())[3]}
---
- Result : `{line[-9:][3].split(".")[1]}`
- Detail
```bash
{list(detail.values())[3]}
```

### {list(detail.keys())[4]}
---
- Result : `{line[-9:][4].split(".")[1]}`
- Detail
```bash
{list(detail.values())[4]}
```

### {list(detail.keys())[5]}
---
- Result : `{line[-9:][5].split(".")[1]}`
- Detail
```bash
{list(detail.values())[5]}
```

### {list(detail.keys())[6]}
---
- Result : `{line[-9:][6].split(".")[1]}`
- Detail
```bash
{list(detail.values())[6]}
```

### {list(detail.keys())[7]}
---
- Result : `{line[-9:][7].split(".")[1]}`
- Detail
```bash
{list(detail.values())[7]}
```

### {list(detail.keys())[8]}
---
- Result : `{line[-9:][8].split(".")[1]}`
- Detail
```bash
{list(detail.values())[8]}
```

'''

result_to_pdf(md)
