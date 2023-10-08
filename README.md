# Centos_Vuln_Scan_Script_to_pdf

## Usage

---

```sh
./setup.sh
python3 result_to_pdf.py
```

## Example

- result.pdf
  ![image](./result.png)

## Description

---

- This python script is only runnable in Centos
- If you want to run in other linux you have to change next files

```text
setup.sh -> install python3 matplotlib pdfkit markdown wkhtmltopdf
total.sh -> vulnerablity check script
result_to_pdf.py -> make script result to markdown -> html -> pdf
```
