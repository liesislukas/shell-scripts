# shell-scripts 😱
These are mostly my own built scripts to make things happen. Some are updated by people I hired to check my mess 🎉

Most of these things are copied from trafikito agent code, which is hosted here: https://github.com/Trafikito/agent


## Functions 🧐
- [log.sh](./log.sh) - exposes 2 functions `fn_log` and `fn_debug`. also manages logs file.
- [fn_promt.sh](./fn_promt.sh) - confirm action with Y/n and then run if statement by result
- [fn_install_tools.sh](./fn_install_tools.sh) - when need to check if some tools are available and if not - try to install it or ask user to do it for you. Defined function `fn_install_tools` which is compatible with Debian, RedHat, Alpine, Arch and SuSE package managers. Defines all tools needed with some description for user
then loops through required tools and tries to install if is root, if not - makes a list for user and prints out. Uses custom [fn_promt.sh](./fn_promt.sh) which can be found in this repo to confirm action.
- [fn_select_edge.sh](./fn_select_edge.sh) - defines default and then pings several URLs to get the fastest edge available.
- [fn_download.sh](./fn_download.sh) -  It's from Trafikito agent installation. It has a list of files to be downloaded from API endpoint and it just tries to get it. Has some retry mechanism in case of network issues.
- [fn_set_os.sh](./fn_set_os.sh) - this will set variables `os`, `os_codename`, `os_release` and `centos_flavor`
- [fn_send_error.sh](./fn_send_error.sh) - function to log and send an error to API endpoint

## Else 🤯
- [promt_2.sh](./promt_2.sh) - another way to promt. This time direct "yes" answer is required
- [define_basedir_when_calling_script.sh](./define_basedir_when_calling_script.sh) - user enters directory to work with as 1st param. e.g. `cmd .` would set base dir to same dir as cmd is called from
- [running_as_root_check.sh](./running_as_root_check.sh) - check if user is running as root and suggest to run as one. 
- [sample_JSON_call.sh](./sample_JSON_call.sh) - Sample how to call API endpoint which consumes JSON
- [sample_FILE_UPLOAD_call.sh](./sample_FILE_UPLOAD_call.sh) - Sample how to call API endpoint and upload file together with multiform request. 
- [sample_kill_processes_by_name.sh](./sample_kill_processes_by_name.sh) - Kill processes by name
- [sample_find_and_config_autorun.sh](./sample_find_and_config_autorun.sh) - Chek if systemd, System V or openRC is available on server and configure running Trafikito agent on one of these mechanics. Also prepare remove script.
