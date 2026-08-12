EC2 RHEL Disk Usage Alert via Gmail SMTP
Complete step-by-step lab documentation
## 1. Objective
Build and test a disk-usage alert on an AWS EC2 RHEL server. The script checks filesystem usage, creates an HTML alert when usage reaches a threshold, and sends the alert through Gmail SMTP using msmtp.
## 2. Lab Environment
- AWS EC2, RHEL 9.7, t3.micro
- Linux user: ec2-user
- Private IP: 172.31.25.38
- Public IP: 3.93.194.128
- Repository directory: ~/shell-script-re
- Mail client: msmtp
- SMTP provider: Gmail
- Recipient/sender used in the lab: saipraveen.immanni@gmail.com
## 3. Architecture
RHEL EC2
  |
```bash
  +--> 22-disk-usage.sh
```
  |       |
  |       +--> df -hT
  |       +--> EC2 Instance Metadata Service
  |       +--> disk threshold check
  |       +--> MESSAGE
  |       |
  |       +--> mail.sh
  |              |
  |              +--> template.html
  |              +--> HTML email
  |              |
  |              +--> msmtp
  |                     |
  |                     +--> ~/.msmtprc
  |                     +--> smtp.gmail.com:587
  |                            |
  |                            +--> Gmail --> Inbox
## 4. Files and Locations
/home/ec2-user/
|
```bash
+-- .msmtprc
```
|
```bash
+-- shell-script-re/
    +-- 22-disk-usage.sh
    +-- mail.sh
    +-- template.html
```
Keep .msmtprc outside the Git repository because it contains the SMTP credential.
## 5. EC2 Metadata
169.254.169.254 is the AWS EC2 Instance Metadata Service endpoint in this context. It is not the EC2 private IP. It is the service address used to ask AWS for information about the current instance.
```bash
curl http://169.254.169.254/latest/meta-data/
```
# Private IP
```bash
curl http://169.254.169.254/latest/meta-data/local-ipv4
```

# Public IP
```bash
curl http://169.254.169.254/latest/meta-data/public-ipv4
```

# Instance type
```bash
curl http://169.254.169.254/latest/meta-data/instance-type
```

# Instance ID
```bash
curl http://169.254.169.254/latest/meta-data/instance-id
```
In this lab, local-ipv4 returned 172.31.25.38.
## 6. Verify the EC2
```bash
whoami
cat /etc/redhat-release
hostname
hostname -I
curl http://169.254.169.254/latest/meta-data/local-ipv4
curl http://169.254.169.254/latest/meta-data/public-ipv4
df -hT
```
## 7. Install and Verify msmtp
```bash
sudo dnf repolist
sudo dnf search msmtp
sudo dnf install msmtp -y
which msmtp
msmtp --version
```
The lab showed msmtp at /usr/bin/msmtp.
## 8. 22-disk-usage.sh
```bash
#!/bin/bash
```

```bash
DISK_USAGE=$(df -hT | grep -v Filesystem)
USAGE_THRESHOLD=10
SERVER_IP=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)
```

while IFS= read -r line
do
    USAGE=$(echo "$line" | awk '{print $6}' | cut -d "%" -f1)
    PARTITION=$(echo "$line" | awk '{print $7}')

    if [ "$USAGE" -ge "$USAGE_THRESHOLD" ]; then
```bash
        MESSAGE+="High Disk Usage on $PARTITION: $USAGE% <br>"
```
    fi
done <<< "$DISK_USAGE"

```bash
echo -e "$MESSAGE"
```

```bash
sh mail.sh "DevOps Team" "High Disk usage" "$SERVER_IP" "$MESSAGE" "saipraveen.immanni@gmail.com" "High Disk Usage Alert"
```
## 9. How 22-disk-usage.sh Works
### df -hT
Lists filesystem usage in human-readable form and includes filesystem type.
### grep -v Filesystem
Removes the df header so the loop processes filesystem rows.
### USAGE_THRESHOLD=10
Triggers an alert for usage greater than or equal to 10%. This low threshold is useful for lab testing.
### SERVER_IP=...
Queries EC2 metadata and gets the current instance private IP.
### while read
Processes each filesystem row one at a time.
### awk '{print $6}'
Extracts the Use% field, such as 38%.
### cut -d '%' -f1
Turns 38% into the number 38 so Bash can compare it.
### awk '{print $7}'
Extracts the mount point, such as /, /var or /boot.
### MESSAGE+=
Appends every high-usage filesystem to one alert message.
### sh mail.sh ...
Passes six arguments to the email script.
## 10. mail.sh
```bash
#!/bin/bash
```

```bash
TO_TEAM=$1
ALERT_TYPE=$2
SERVER_IP=$3
MESSAGE=$4
```
TO_ADDRESS=$5
SUBJECT=$6

```bash
FINAL_MESSAGE=$(echo "$MESSAGE" | sed -e 's/[&/]/\\&/g')
```

```bash
FINAL_BODY=$(sed \
```
    -e "s/TO_TEAM/$TO_TEAM/g" \
    -e "s/ALERT_TYPE/$ALERT_TYPE/g" \
    -e "s/SERVER_IP/$SERVER_IP/g" \
    -e "s/MESSAGE/$FINAL_MESSAGE/g" \
    template.html)

{
```bash
    echo "To: $TO_ADDRESS"
    echo "Subject: $SUBJECT"
    echo "Content-Type: text/html"
    echo ""
    echo "$FINAL_BODY"
```
} | msmtp "$TO_ADDRESS"
## 11. mail.sh Arguments
```bash
sh mail.sh "DevOps Team" "High Disk usage" "$SERVER_IP" "$MESSAGE" "saipraveen.immanni@gmail.com" "High Disk Usage Alert"
```

```bash
$1 = DevOps Team
$2 = High Disk usage
$3 = server private IP
$4 = disk alert message
$5 = recipient email
$6 = email subject
```
## 12. template.html
```bash
<p>Hi TO_TEAM,</p>
<p>&nbsp;</p>
<p>There is an alert <span style="color: #ff0000;"><strong>ALERT_TYPE</strong></span> in the below server. Please check asap.</p>
<p><strong>IP: SERVER_IP</strong></p>
<p>&nbsp;</p>
<p><span style="color: #ff0000;">MESSAGE</span></p>
<p>&nbsp;</p>
<p>Regards,</p>
<p>LinuxAdmin Team</p>
TO_TEAM, ALERT_TYPE, SERVER_IP and MESSAGE are placeholders. mail.sh replaces them before sending. The HTML tags provide paragraphs, bold text and red alert text.
```
## 13. Gmail 2-Step Verification and App Password
For this lab, Gmail SMTP was used with a Google App Password. 2-Step Verification was enabled first, then an App Password was created for the msmtp application.
- Enable 2-Step Verification on the Google account.
- Open Google Account Security and find App passwords.
- Create an App Password for the EC2/msmtp use case.
- Google may display the App Password in groups of four characters. Enter it without spaces in .msmtprc.
- Never share the App Password or commit it to GitHub.
- Do not use the normal Gmail password in .msmtprc.
## 14. Create ~/.msmtprc Using Vim
The EC2 image did not have nano, so Vim was used. Create the file in the ec2-user home directory, not in ~/shell-script-re.
```bash
vim ~/.msmtprc
```
Press i for INSERT mode, then enter:
```bash
defaults
auth on
tls on
tls_starttls on
```
tls_trust_file /etc/pki/tls/certs/ca-bundle.crt
logfile ~/.msmtp.log

```bash
account default
host smtp.gmail.com
port 587
from saipraveen.immanni@gmail.com
user saipraveen.immanni@gmail.com
password YOUR_APP_PASSWORD
```
Replace YOUR_APP_PASSWORD with the 16-character Google App Password, without spaces.
Save and exit Vim:
```bash
Esc
:wq
Enter
```
Secure the file:
```bash
chmod 600 ~/.msmtprc
ls -l ~/.msmtprc
```
Expected permissions: -rw------- for .msmtprc.
## 15. Test msmtp Independently
Always test the email component independently before testing the complete monitoring script. This makes troubleshooting much easier.
```bash
printf "Subject: EC2 Test Email\n\nThis is a test email from my RHEL EC2 server.\n" | msmtp saipraveen.immanni@gmail.com
echo $?
```
A return code of 0 indicates success. Verify the message in Gmail Inbox or Spam.
## 16. The sudo Problem
The first attempt used sudo and failed with: msmtp: account default not found: no configuration file available. The reason is that sudo runs the script as root. msmtp then looks for /root/.msmtprc, while the working configuration was /home/ec2-user/.msmtprc.
# Correct for this lab
```bash
sh 22-disk-usage.sh
```

# Causes the root configuration problem
```bash
sudo sh 22-disk-usage.sh
```
No sudo is required for this disk-monitoring script.
## 17. Final Execution
cd ~/shell-script-re
```bash
sh 22-disk-usage.sh
```
The successful lab run produced:
High Disk Usage on /: 38% <br>
High Disk Usage on /var: 34% <br>
High Disk Usage on /boot: 81% <br>
The Gmail inbox received the High Disk Usage Alert. The email showed DevOps Team, High Disk usage, private IP 172.31.25.38, and the three detected high-usage filesystems.
## 18. Complete Troubleshooting
### msmtp command not found
Install with sudo dnf install msmtp -y and verify with which msmtp.
### No .msmtprc
Create /home/ec2-user/.msmtprc with Vim: vim ~/.msmtprc.
### msmtp account default not found
Ensure ~/.msmtprc exists for the user running msmtp. Do not use sudo for the script.
### Direct msmtp test works but script fails
Check whether the script was launched as root. Run sh 22-disk-usage.sh as ec2-user.
### No email arrives
Run the standalone msmtp test and inspect ~/.msmtp.log. Check Gmail Spam.
### Metadata command returns 172.31.25.38
That is expected for local-ipv4. It is the EC2 private IP.
### Need the public IP
Use curl http://169.254.169.254/latest/meta-data/public-ipv4.
### Vim instead of nano
```bash
vim ~/.msmtprc; press i; enter configuration; Esc; :wq; Enter.
```
### Credentials exposed
Never commit .msmtprc or the App Password to GitHub. Keep .msmtprc outside the repository.
## 19. Security and Production Notes
- Keep the Gmail App Password secret.
- Keep ~/.msmtprc outside Git and set chmod 600.
- Do not use a personal mailbox as a production alerting account if a dedicated service is available.
- The 10% threshold is intentionally low for lab testing. A higher threshold such as 80% is more realistic for many environments.
- Use IMDSv2 where appropriate and consider enforcing it for production EC2 instances.
- Do not hard-code an EC2 public IP because it can change after stop/start unless a stable addressing solution is used.
- For production monitoring, consider CloudWatch alarms or a dedicated monitoring/alerting platform.
## 20. Final Verification Checklist
- ☐ EC2 RHEL server is running and accessible.
- ☐ EC2 metadata service responds.
- ☐ Private IP is 172.31.25.38.
- ☐ Public IP is 3.93.194.128 at the time of this lab.
- ☐ msmtp is installed at /usr/bin/msmtp.
- ☐ 22-disk-usage.sh, mail.sh and template.html exist in ~/shell-script-re.
- ☐ Gmail 2-Step Verification is enabled.
- ☐ Gmail App Password is created and kept secret.
- ☐ ~/.msmtprc exists under /home/ec2-user.
- ☐ ~/.msmtprc permissions are 600.
- ☐ Standalone msmtp test email reaches Gmail.
- ☐ 22-disk-usage.sh detects high disk usage.
- ☐ mail.sh reads template.html and creates the HTML email.
- ☐ Final alert email reaches saipraveen.immanni@gmail.com.
## 21. Quick Re-run Procedure
cd ~/shell-script-re

```bash
which msmtp
curl http://169.254.169.254/latest/meta-data/local-ipv4
df -hT
```

```bash
sh 22-disk-usage.sh
```
## 22. Final Result
The complete lab was successfully implemented and tested. The RHEL EC2 server detected high disk usage, generated the alert message, populated an HTML template, authenticated through Gmail SMTP using msmtp, and delivered the High Disk Usage Alert to the Gmail inbox.