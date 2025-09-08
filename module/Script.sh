#!/system/bin/sh
#Author: 幽影WF
#Re-creation: yu13140 [whmyc801@gmail.com]
CUSTOM_NUMBER=0 #发现的隐藏应用数量 将0改为自己被发现的隐藏应用数量
ENABLE_SCRIPT=true
#解决发现隐藏应用配置
TARGET_DIR="/data/app"
PATHS=( #可添加自定义sus路径   
    "/dev/scene"
    "/dev/cpuset/scene-daemon"
    "/dev/cpuset/AppOpt"
    "/data/sys_elsa_config_list.xml"
    "/system/addon.d"
    "/vendor/bin/install-recovery.sh"
    "/sdcard/TWRP"
    "/sdcard/Fox"
    "/sdcard/MT2"
)
deny_list=(
    "com.silverlab.app.deviceidchanger.free"
    "me.bingyue.IceCore"
    "com.modify.installer"
    "o.dyoo"
    "com.zhufucdev.motion_emulator"
    "me.simpleHook"
    "com.cshlolss.vipkill"
    "io.github.a13e300.ksuwebui"
    "com.demo.serendipity"
    "me.iacn.biliroaming"
    "me.teble.xposed.autodaily"
    "com.example.ourom"
    "dialog.box"
    "top.hookvip.pro"
    "tornaco.apps.shortx"
    "moe.fuqiuluo.portal"
    "com.github.tianma8023.xposed.smscode"
    "moe.shizuku.privileged.api"
    "lin.xposed"
    "com.lerist.fakelocation"
    "com.yxer.packageinstalles"
    "xzr.hkf"
    "web1n.stopapp"
    "Hook.JiuWu.Xp"
    "io.github.qauxv"
    "com.houvven.guise"
    "xzr.konabess"
    "com.xayah.databackup.foss"
    "com.sevtinge.hyperceiler"
    "github.tornaco.android.thanos"
    "nep.timeline.freezer"
    "cn.geektang.privacyspace"
    "org.lsposed.lspatch"
    "zako.zako.zako"
    "com.topmiaohan.hidebllist"
    "com.tsng.hidemyapplist"
    "com.tsng.pzyhrx.hma"
    "com.byyoung.setting"
    "com.omarea.vtools"
    "cn.myflv.noactive"
    "io.github.vvb2060.magisk"
    "com.bug.hookvip"
    "com.junge.algorithmAidePro"
    "bin.mt.termex"
    "tmgp.atlas.toolbox"
    "com.wn.app.np"
    "com.sukisu.ultra"
    "ru.maximoff.apktool"
    "top.bienvenido.saas.i18n"
    "com.syyf.quickpay"
    "tornaco.apps.shortx.ext"
    "com.mio.kitchen"
    "eu.faircode.xlua"
    "com.dna.tools"
    "cn.myflv.monitor.noactive"
    "com.yuanwofei.cardemulator.pro"
    "com.termux"
    "com.suqi8.oshin"
    "me.hd.wauxv"
    "have.fun"
    "miko.client"
    "com.kooritea.fcmfix"
    "com.twifucker.hachidori"
    "com.luckyzyx.luckytool"
    "com.padi.hook.hookqq"
    "cn.lyric.getter"
    "com.parallelc.micts"
    "me.plusne"
    "com.hchen.appretention"
    "com.hchen.switchfreeform"
    "name.monwf.customiuizer"
    "com.houvven.impad"
    "cn.aodlyric.xiaowine"
    "top.sacz.timtool"
    "nep.timeline.re_telegram"
    "com.fuck.android.rimet"
    "cn.kwaiching.hook"
    "cn.android.x"
    "cc.aoeiuv020.iamnotdisabled.hook"
    "vn.kwaiching.tao"
    "com.nnnen.plusne"
    "com.fkzhang.wechatxposed"
    "one.yufz.hmspush"
    "cn.fuckhome.xiaowine"
    "com.fankes.tsbattery"
    "com.rifsxd.ksunext"
    "com.rkg.IAMRKG"
    "me.gm.cleaner"
    "moe.shizuku.redirectstorage"
    "com.ddm.qute"
    "io.github.vvb2060.magisk"
    "kk.dk.anqu"
    "com.qq.qcxm"
    "com.wei.vip"
    "dknb.con"
    "dknb.coo8"
    "com.tencent.jingshi"
    "com.tencent.JYNB"
    "com.apocalua.run"
    "com.coderstory.toolkit"
    "com.didjdk.adbhelper"
    "org.lsposed.manager"
    "io.github.Retmon403.oppotheme"
    "com.fankes.enforcehighrefreshrate"
    "es.chiteroman.bootloaderspoofer"
    "com.hchai.rescueplan"
)

clean_dirs=(
    "/storage/emulated/0/Android/data"
    "/storage/emulated/0/Android/media"
    "/storage/emulated/0/Android/obb"
)

echo "===== 开始执行一键配置sus路径 ====="
echo "===== author:酷安@幽影WF ====="

# 查找 ksu_susfs
KSUSFS_DIR="/data/adb/ksu/bin"
echo "在 $KSUSFS_DIR 中查找 ksu_susfs "

# 获取所有匹配的文件
KSUSFS_FILES=$(find "$KSUSFS_DIR" -maxdepth 1 -type f -name "*ksu_susfs*" 2>/dev/null | sort)

if [[ -z "$KSUSFS_FILES" ]]; then
    echo "❌ 错误: 在 $KSUSFS_DIR 目录下未找到 ksu_susfs 文件"
    exit 1
fi

LATEST_VERSION=""
LATEST_FILE=""
for file in $KSUSFS_FILES; do
    # 提取文件名
    filename=$(basename "$file")
    
    version=$(echo "$filename" | grep -Eo 'ksu_susfs_([0-9.]+)' | sed 's/ksu_susfs_//')
       if [[ -n "$version" ]]; then
        echo "找到文件: $filename - 版本号: $version"
        
        if [[ -z "$LATEST_VERSION" ]] || [[ "$version" > "$LATEST_VERSION" ]]; then
            LATEST_VERSION="$version"
            LATEST_FILE="$file"
        fi
    else
        echo "找到文件: $filename - 无版本号"
        if [[ -z "$LATEST_FILE" ]]; then
            LATEST_FILE="$file"
        fi
    fi
done

SUSFS_BIN="$LATEST_FILE"
echo "✅ 使用最新版本: $SUSFS_BIN"

if ! "$SUSFS_BIN" set_android_data_root_path '/sdcard/Android/data/' 2>/dev/null; then
    susfs_checking
fi

"$SUSFS_BIN" set_sdcard_root_path '/sdcard/'

for path in "${PATHS[@]}"; do
    if [[ -d $path ]] || [[ -f $path ]]; then
        if "$SUSFS_BIN" add_sus_path "$path"; then
            echo "Succced✅: $path 已添加"
        else
            echo "Error: $path 处理失败"
        fi
    fi
done

echo "自定义路径处理完成"
sleep 1

# 获取/data/app文件夹数量
dir_count=$(find "$TARGET_DIR" -mindepth 1 -maxdepth 1 -type d | wc -l)

CUSTOM_NUMBER=0
for app_path in "${deny_list[@]}"; do
    if [[ -d "/sdcard/Android/data/$app_path" ]]; then
        CUSTOM_NUMBER=$((CUSTOM_NUMBER + 1))
        if "$SUSFS_BIN" add_sus_path "/sdcard/Android/data/$app_path"; then
            echo "Succced✅: $app_path 已添加"
        else
            echo "Error: $app_path 处理失败"
        fi        
    fi
done

    # 计算 number 值 (文件夹数量 - 发现的隐藏应用数量 + 2)
    number=$((dir_count - CUSTOM_NUMBER + 2))

    echo "计算配置数值 = $dir_count - $CUSTOM_NUMBER + 2 = $number"
    echo "--------------------------------"

    echo "执行 SUSFS 命令✅"
    "$SUSFS_BIN" add_sus_kstat_statically \
        "$TARGET_DIR/" \
        'default' 'default' "$number" 'default' 'default' 'default' \
        'default' 'default' 'default' 'default' 'default' 'default'

    echo "更新 SUSFS 状态成功✅"
    "$SUSFS_BIN" update_sus_kstat "$TARGET_DIR/"

    echo "--------------------------------"

echo ""
echo ""

echo "===== 开始执行自动获取隐藏UID目录 ====="

# 查找目标目录
echo "正在搜索隐藏应用列表的配置目录..."
hide_dir=$(find "/data/misc" -maxdepth 1 -type d -name "*hide_my_applist*" 2>/dev/null | head -n1)

# 设置默认目标目录
if [[ -n "$hide_dir" ]]; then
    DEFAULT_TARGET_DIR="$hide_dir"
    echo "✅ 成功获取到隐藏应用列表配置文件夹: $DEFAULT_TARGET_DIR"
else
    DEFAULT_TARGET_DIR=""
fi

if [[ -n "$DEFAULT_TARGET_DIR" ]]; then
    target_dir="$DEFAULT_TARGET_DIR"
else
    echo "❌ 错误: 未找到隐藏应用列表配置目录"
    exit 1
fi

# 确保目录存在
if [[ ! -d "$target_dir" ]]; then
    echo "❌ 错误: 目录 $target_dir 不存在"
    exit 1
fi

# 配置文件路径
config_file="${target_dir%/}/config.json"

# 检查配置文件是否存在
if [[ ! -f "$config_file" ]]; then
    echo "❌ 错误: 在目录 $target_dir 中未找到 config.json 文件"
    exit 1
fi

echo "找到配置文件: $config_file"

echo "解析隐藏应用列表配置文件..."

# 读取文件内容
content=$(cat "$config_file")

# 提取所有黑名单应用列表
app_lists=$(echo "$content" | grep -o '"appList":\[[^]]*\]')

# 未找到任何应用列表 退出脚本
if [[ -z "$app_lists" ]]; then
    echo "❌ 未找到任何应用列表"
    exit 0
fi

# 查找包含最多应用的黑名单列表
best_list=""
max_count=0

while IFS= read -r list; do
    # 检查这个列表是否属于黑名单
    context=$(echo "$content" | grep -o '"[^"]*":{[^}]*"isWhitelist":false[^}]*}')
    
    # 检查上下文是否包含当前应用列表
    if echo "$context" | grep -qF "$list"; then
        # 提取应用列表
        apps=$(echo "$list" | sed 's/"appList"://;s/\[//;s/\]//;s/"//g')
        
        # 计算应用数量
        count=$(echo "$apps" | awk -F, '{print NF}')
        
        if [[ $count -gt $max_count ]]; then
            max_count=$count
            best_list="$apps"
        fi
    fi
done <<< "$app_lists"

# 检查是否找到有效的应用列表
if [[ -z "$best_list" ]]; then
    echo "❌ 未找到符合条件的黑名单应用列表"
    exit 0
fi

echo "✅ 成功提取应用列表，包含 $max_count 个应用"

# 检查 packages.list 文件是否存在
if [[ ! -f "/data/system/packages.list" ]]; then
    echo "❌ Error: /data/system/packages.list 文件不存在"
    exit 1
fi

# 将应用包名列表转换为 UID
uids=""
for app in $(echo "$best_list" | tr ',' ' '); do
    # 在 packages.list 中查找包名对应的 UID
    uid_line=$(grep -E "^$app[[:space:]]" "/data/system/packages.list" 2>/dev/null)
    
    if [[ -n "$uid_line" ]]; then
        # 提取 UID
        uid=$(echo "$uid_line" | awk '{print $2}')
        
        if [[ -n "$uid" ]]; then
            # 添加
            uids="${uids}${uid} "
            echo "$app -> UID: $uid"
        fi
    else
        echo "⚠️ 未找到应用: $app"
    fi
done

# 移除末尾空格
uids=$(echo "$uids" | xargs)

# 检查是否获取到 UID
if [[ -z "$uids" ]]; then
    echo "❌ 未找到有效的 UID"
    exit 0
fi

echo "✅ 成功获取 UID 列表: $uids"

# 扫描 /sys/fs/cgroup 目录
cgroup_dir="/sys/fs/cgroup"
uid_dirs=""

echo "扫描 $cgroup_dir 目录..."
for dir in $(find "$cgroup_dir" -maxdepth 1 -type d -name "uid_*" 2>/dev/null); do
    # 提取目录名中的 UID 部分
    dir_uid=$(basename "$dir" | sed 's/uid_//')
    
    # 检查该 UID 是否在列表中
    if echo "$uids" | grep -qw "$dir_uid"; then
        uid_dirs="${uid_dirs}${dir}\n"
    fi
done

# 检查是否找到匹配的目录
if [ -z "$uid_dirs" ]; then
    echo "❌ 未找到匹配的 UID 目录"
    exit 0
fi

echo "✅ 找到所有匹配的 UID 目录"

# 处理匹配目录
processed_dirs=""
total_dirs=0
skipped_dirs=0

echo -e "$uid_dirs" | while IFS= read -r dir; do
    [[ -z "$dir" ]] && continue
    total_dirs=$((total_dirs + 1))

    echo "⚙️ 处理目录: $dir"
    # 执行添加操作
    "$SUSFS_BIN" add_sus_path "$dir" >/dev/null 2>&1        

    processed_dirs="${processed_dirs}${dir}\n"
done

echo "处理完毕✅"
echo "===== 自动获取隐藏UID目录并执行sus完成 ====="
echo "===== author:酷安@幽影WF ====="

echo "===== 正在清理外部储存(可选) ====="
options=("是" "否")
PS3="请问是否要清理？"
select choice in "${options[@]}"; do
    case $extra_choice in
        "是")
         echo "即将开始清理……"; break ;;
        "否")
         echo "正在退出脚本……"; exit 0 ;;
        *) 
         echo "输入错误，退出脚本。"; exit 0 ;;
    esac
done

for base_dir in "${clean_dirs[@]}"; do
    for app_path in "${deny_list[@]}"; do
        target_path="$base_dir/$app_path"
        if [ -d "$target_path" ]; then
            echo "🗑️ 已删除: $target_path"
            rm -rf "$target_path"
        fi
    done
done

echo "清理完成✅"
echo "========================================"

# 由 susfs4ksu 的 action.sh 修改而来
susfs_checking() {
SUSFSD=/data/adb/ksu/bin/susfsd
KSU_BIN=/data/adb/ksu/bin/
TMPDIR=/data/adb/ksu/susfs4ksu

echo "***************************************"
echo "SUSFS4KSU Userspace tool update script"
echo "***************************************"

ver=$(uname -r | cut -d. -f1)
if [ ${ver} -lt 5 ]; then
    KERNEL_VERSION=non-gki
	echo "[-] Non-GKI kernel detected... use non-GKI susfs bins..."
    SUSFS_VERSION_RAW=$(${SUSFSD} version)
    # Example output = 'v1.5.3'
    SUSFS_DECIMAL=$(echo "$SUSFS_VERSION_RAW" | sed 's/^v//; s/\.//g')
    # SUSFS_DECIMAL = '153'
else
	KERNEL_VERSION=gki
	echo "[-] GKI kernel detected... use GKI susfs bins..."
    SUSFS_VERSION_RAW=$(${SUSFSD} version)
    # Example output = 'v1.5.3'
    SUSFS_DECIMAL=$(echo "$SUSFS_VERSION_RAW" | sed 's/^v//; s/\.//g')
    # SUSFS_DECIMAL = '153'
fi

echo "[-] Kernel is using susfs $SUSFS_VERSION_RAW"
echo "[-] Downloading susfs $SUSFS_VERSION_RAW from the internet"

rshy --download "https://raw.githubusercontent.com/sidex15/susfs4ksu-binaries/main/$1/$2/ksu_susfs_arm64" "${TMPDIR}/ksu_susfs_remote"
chmod +x ${TMPDIR}/ksu_susfs_remote

if ${TMPDIR}/ksu_susfs_remote > /dev/null 2>&1 ; then
    cp -f ${TMPDIR}/ksu_susfs_remote ${KSU_BIN}/ksu_susfs
    echo "[-] Update Complete!"
else
    echo "[!] Download Test Failed"
    echo "[!] Update Failed"
fi
}
