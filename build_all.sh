#!/bin/bash
# build_all.sh
# Copyright (c) 2017 Your Name <your@mail>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#!/bin/bash
#Warning:package name mustn't be illegal characters or space blank

#--------------------------------------------------------------------------
#(configuration item)
#--------------------------------------------------------------------------
CUR=
CURRENT_DIR=`pwd`
SCRIPTS_DIR=$CURRENT_DIR/plugin/script

vim_src_package=vim-8.0.tar.bz2
vim_src_git=vim80

cscope_src_package=cscope-15.8b.tar.gz
cscope_src_git=cscope-15.8b

ctags_src_package=ctags-5.8.tar.gz
ctags_src_git=ctags-5.8

MAKE=make
MKCLEAN=distclean
MKINSTALL=install
MKARGS=-j4
SUDO=
CONFIG=./configure
CFG_ARGS=--prefix=/usr

HOSTOS=`uname -v | \
        awk -F ' ' '{print $1}' | \
        awk -F '-' '{print $2}' | \
        tr '[:upper:]' '[:lower:]'`


#==============================
#vimtool configuration
#==============================
VIMTOOL_ROOT=`pwd`                  #vimtool顶层目录
VIMTOOL_PLUGIN=$VIMTOOL_ROOT/plugin
VIMTOOL_PLG_SCRIPT=$VIMTOOL_PLUGIN/script
VIMTOOL_PLG_SOURCE=$VIMTOOL_PLUGIN/source
VIMTOOL_VIM=$VIMTOOL_ROOT/vim
VIMTOOL_DOC=$VIMTOOL_ROOT/doc
VIMTOOL_CONFIG=$VIMTOOL_ROOT/config
VIMRC=vimrc.vim                     #config/vimrc
OBJECT_TOOL=object.sh               #config/object.sh
VIM_CFG_DIR=$HOME/.vim
VIM_CFG_DIR_PLUGIN=$VIM_CFG_DIR/plugin
VIM_CFG_DIR_DOC=$VIM_CFG_DIR/doc
VIM_CFG_DIR_AUTOLOAD=$VIM_CFG_DIR/autoload
OBJECT_TOOL_PATH=/usr/bin
TEMP_FILE=$HOME/seafly_temp

TAR=tar
UNZIP=unzip
DEL_DIR="rm -rf"

ARG_DOT_TAR=-xvf            #xxx.tar
ARG_DOT_TAR_GZ=-xzvf        #xxx.tar.gz  or xxx.tgz
ARG_DOT_TAR_BZ2=-xjvf       #xxx.tar.bz2


#=================================================
#vim editor
#=================================================
VIM=vim-8.0.tar.bz2             #vim source package name
TAR_VIM=$TAR                    #decompress package tool
TAR_VIM_ARGS=$ARG_DOT_TAR_BZ2   #decompress command arguments
VIM_DIR=vim80                   #vim_dir after decompression
#auto get python directory name
list=`ls /usr/lib | grep "python"`
ls /usr/lib | grep "python" > ${TEMP_FILE}
python_version=`awk -F . '{print $1}' ${TEMP_FILE}`	#python2
value=
ret=
for value in $list
do
    ret=$value
    echo "$value" > ${TEMP_FILE}
    value=`awk -F . '{print $1}' ${TEMP_FILE}`
    if [ "$value" == "${python_version}" ] ;	#main support python2.x  !!!!!!
    then
	break
    fi
done
PY_VERSION=$ret
VIM_CONFIG=(./configure \
    --prefix=/usr \
    --with-features=huge \
    --enable-rubyinterp \
    --enable-pythoninterp=yes \
    --enable-python3interp=yes \
    --enable-luainterp \
    --enable-perlinterp \
    --enable-multibyte \
    --enable-cscope \
    --with-python-config-dir=/usr/lib/python2.6/config)
#    --with-python-config-dir=/usr/lib/${PY_VERSION}/config)
#echo "VIM_CONFIG: ${VIM_CONFIG[*]}"        #print all element of array
#======================================================================
####--with-features=huge \
####--with-features=big \
####--enable-cscope \
####--enable-multibyte \


BVI=bvi-1.4.0-src-11.31.tar.gz             #vim source package name
TAR_BVI=$TAR                    #decompress package tool
TAR_BVI_ARGS=$ARG_DOT_TAR_GZ   #decompress command arguments
BVI_DIR=bvi-1.4.0                  #vim_dir after decompression
#auto get python directory name
BVI_CONFIG=(./configure \
    --prefix=/usr)


#==================================================
#Following are source packages (need to be compiled) plugins
#You should follow the format of following arguments if you want to modify it or add others
CTAGS=ctags-5.8.tar.gz
TAR_CTAGS=$TAR                #decompressing with tar
TAR_CTAGS_ARGS=$ARG_DOT_TAR_GZ
CTAGS_DIR=ctags-5.8

CSCOPE=cscope-15.8b.tar.gz
TAR_CSCOPE=$TAR
TAR_CSCOPE_ARGS=$ARG_DOT_TAR_GZ
CSCOPE_DIR=cscope-15.8b


#------------------------------------------------
#functions' implement
#------------------------------------------------
function debug_vimtool()
{

    echo "function debug_vimtool()>>>complete installation total list"
    read temporary
    echo "function install_vimtool()>>>installation main function"
    echo "function install_vimtool()>>>complete installation"
    echo "function install_vim()>>>install vim"
    echo "function only_vim()>>>only install vim"
    echo "function install_plugin()>>>install plugins"
    echo "function source_plugin()>>>source code plugins"
    echo "function source_tar_plugin()>>>*.tar format source plugin packages"
    echo "function source_zip_plugin()>>>*.zip format source plugin packages"
    echo "function source_tar_gz_plugin()>>>*.tar.gz format source plugin packages"
    echo "function source_tar_bz2_plugin()>>>*.tar.bz2 format source plugin packages"
    echo "function script_plugin()>>> script plugins"
    echo "function script_vim_plugin()>>>*.vim format plugins"
    echo "function script_tar_plugin()>>>*.tar format plugins"
    echo "function script_zip_plugin()>>>*.zip format plugins"
    echo "function script_tar_gz_plugin():*.tar.gz format plugins"
    echo "function script_tar_bz2_plugin()>>>*.tar.bz2 format plugins"
    echo "function install_config()>>>install configuration files"
    echo "function config_object()>>>install object configuration file(s)"
    echo "function config_vimrc()>>>install vimrc configuration file(s)"
    echo " "
    echo " "
    echo debugingdebugingdebugingdebugingdebuging ;read debuging
    echo debugingdebugingdebugingdebugingdebuging ;read debuging
    echo debugingdebugingdebugingdebugingdebuging ;read debuging
    echo debugingdebugingdebugingdebugingdebuging ;read debuging
    echo debugingdebugingdebugingdebugingdebuging ;read debuging
    echo debugingdebugingdebugingdebugingdebuging ;read debuging
    echo debugingdebugingdebugingdebugingdebuging ;read debuging
    echo debugingdebugingdebugingdebugingdebuging ;read debuging
    echo debugingdebugingdebugingdebugingdebuging ;read debuging
    echo debugingdebugingdebugingdebugingdebuging ;read debuging
    echo debugingdebugingdebugingdebugingdebuging ;read debuging
    echo debugingdebugingdebugingdebugingdebuging ;read debuging
    exit 0
    return 0
}

function vimtool_finish()
{
    #=================================================================
    #installation finished
    #=================================================================
    echo "CUR: ${CUR}"   #/root/home/user1/vimtool
    echo "Finish installation! Please read doc/xxx.pdf for reference"
    echo "Note"
    echo "    Run vim first time, you need goto ~/.vim/doc, likes following commands:"
    echo "    # cd ~/.vim/doc"
    echo "    # vim"
    echo "         "
    echo "    and then run following 'vim-command':"
    echo "    :helptags ./       (It can load help files into vim)"
    echo "    (If you add other plugins help file(s), replay above stage)"
    echo " "
    echo "Press <Enter> look following message...(Press <Ctrl-c> to ignore)"
    read temporary
    clear
    echo "Manual:(Readme!)"
    echo ""
    echo "    step01 cd ~/your_object_dir"
    echo "    step02 run object.sh directly"
    echo "           (execute object.sh if you want to update object_depend_file)"
    echo "    step03 run vim"
    echo "           Press <F3> load tags file"
    echo "           Press <F4> load cscope file"
    echo "    "
    echo "           Press <F12> open the winmanager window(selectable)"
    echo "    "
    echo "    After above operations, we have finished initialazation of object"
    echo "    and then you can see vimtool/doc/xxx.pdf for details"
    echo " "
    echo "    (Installation details: vimtool/build_all)"
    echo "    (Plugin configuration: vimtool/config/vimrc)"
    echo "    (Object configuration: vimtool/config/object.sh)"
    echo "                                    E-mail: seafly0616@qq.com"
    #=================================================================
    
}

function build_all_help()
{
    echo "Simple installation information:"
    echo "    ./build_all               #Complete install vimtool(Recommend first use)"
    echo "    ./build_all only_vim      #Only install vim"
    echo "    ./build_all no_vim        #Only install plugins"
    echo "    ./build_all script_plugin #Only install script plugins"
    echo "    ./build_all source_plugin #Only install source plugins"
    echo "    ./build_all update_config #Only install configuration files"


    echo "Helpful information of first-use"
    echo "    # cd ~/.vim/doc"
    echo "    # vim"
    echo "         "
    echo "    Then run following command to load help files"
    echo "    :helptags ./ "
    echo "    (If you add other new plugins, replay above stage)"
    echo " "
    echo "Press <Enter> to continue...(Press <Ctrl-c> to ignore)"
    read temporary
    clear
    echo "Manual:(Readme!)"
    echo ""
    echo "    step01 cd ~/your_object_dir"
    echo "    step02 run object.sh directly"
    echo "           (execute object.sh if you want to update object_depend_file)"
    echo "    step03 run vim"
    echo "           Press <F3> load tags file"
    echo "           Press <F4> load cscope file"
    echo "    "
    echo "           Press <F12> open the winmanager window(selectable)"
    echo "    "
    echo "    After above operations, we have finished initialazation of object"
    echo "    and then you can see vimtool/doc/xxx.pdf for details"
    echo " "
    echo "    (Installation details: vimtool/build_all)"
    echo "    (Plugin configuration: vimtool/config/vimrc)"
    echo "    (Object configuration: vimtool/config/object.sh)"
    echo "                                    E-mail: seafly0616@qq.com"
    #=================================================================
    
}


function only_vim()
{
    if [ $HOSTOS == "ubuntu" ] ;
    then
        host www.baidu.com 1>/dev/null 2>/dev/null
        if [ $? -ne 0 ] ;
        then
            echo "网络不支持，所以只能源码方式安装vim了(缺库的话就没办法咯)"
            cd $CURRENT_DIR/vim && \
                tar -xjvf $vim_src_package && \
                cd $vim_src_git && \
                ./configure --prefix=/usr --with-features=huge \
                --enable-cscope --enable-multibyte && \
                make && $SUDO make install && \
                cd .. && rm -rf $vim_src_git
            return 0
        fi

        $SUDO apt-get install -y vim
        $SUDO apt-get install -y vim-gocomplete
        $SUDO apt-get install -y vim-syntax-gtk
        $SUDO apt-get install -y vim-tiny
        $SUDO apt-get install -y vim-vim-youcompleteme
        $SUDO apt-get install -y vim-python-jedi
        $SUDO apt-get install -y vim-scripts
        $SUDO apt-get install -y vim-syntax-go
        $SUDO apt-get install -y vim-syntax-docker
        $SUDO apt-get install -y vim-gnome
        $SUDO apt-get install -y vim-doc
        $SUDO apt-get install -y vim-dbg
        $SUDO apt-get install -y vim-common
        $SUDO apt-get install -y vim-gtk
        $SUDO apt-get install -y vim-gui-common
        $SUDO apt-get install -y vim-vimerl
        $SUDO apt-get install -y vim-vimerl-syntax
        $SUDO apt-get install -y vim-outliner
        $SUDO apt-get install -y vim-runtime
        return 0
    fi

    #redhat or centOS
    host www.baidu.com 1>/dev/null 2>/dev/null
    if [ $? -ne 0 ] ;
    then
        echo "网络不支持，所以只能源码方式安装vim了(缺库的话就没办法咯)"
        cd $CURRENT_DIR/vim && \
            tar -xjvf $vim_src_package && \
            cd $vim_src_git && \
            ./configure --prefix=/usr --with-features=huge \
            --enable-cscope --enable-multibyte && \
            make && $SUDO make install && \
            cd .. && rm -rf $vim_src_git
        return 0
    fi

    echo "function only_vim()>>>only install vim"
    $SUDO yum install -y vim
    $SUDO yum install -y vim-X11
    $SUDO yum install -y vim-gtk-syntax
    $SUDO yum install -y vim-minimal
    $SUDO yum install -y golang-vim
    $SUDO yum install -y vim-filesystem
    $SUDO yum install -y vim-go
    $SUDO yum install -y vim-vimoutliner
    echo "only_vim():successfully!"
    return 0
}

function source_tar_gz_plugin()
{
    echo "function source_tar_gz_plugin()>>>*.tar.gz  script plugins"
    [ -d $VIM_CFG_DIR ]
    if [ $? -ne 0 ] ;
    then
        mkdir -p $VIM_CFG_DIR
    fi

    cp -v $VIMTOOL_PLG_SOURCE/*.tar.gz $VIM_CFG_DIR
    cd $VIM_CFG_DIR

    local value=
    local value_dir=
    local list=`ls *.tar.gz`
    echo "list: $list"
    for value in $list
    do
        if [ -z $value ] ;
        then
            break
        fi

        #检查value是否为普通 script plugins
        if [ $value == "netrw-93.tar.gz" ] ;
        then
            echo "$value isn't a source package"
        elif [ $value == "vimcdoc-1.5.0.tar.gz" ] ;
        then
            echo "$value isn't a source package"
        else
            echo ""
        fi

        #解压压缩包
        $TAR $ARG_DOT_TAR_GZ $value

        #获取压缩包解压之后的目录:这里直接根据命名规则获取
        #还有其它获取方式等用到再说
        echo "$value" > $TEMP_FILE
        echo "value: $value"
        value_dir=`awk -F . '{print $1}' $TEMP_FILE`
        value_dir=${value_dir}.
        value_dir=${value_dir}`awk -F . '{print $2}' $TEMP_FILE`
        echo "value_dir: $value_dir"

        #测试解压之后的目录的有效性#失败，则通过另一种方式(*)获取
        cd $VIM_CFG_DIR/$value_dir
        if [ $? -ne 0 ] ;
        then
            echo "$value" > $TEMP_FILE
            value_dir=`awk -F - '{print $1}' $TEMP_FILE`
            value_dir=${value_dir}*
            cd ${value_dir}
            if [ $? -ne 0 ] ;
            then
                #手动指定解压之后的目录名:不用写绝对路径:vim80
                echo    "无法获取解压之后的目录名,"
                echo    "当前压缩包解压名: $value"
                echo    "请手动输入当前压缩包解压之后的目录名,"
                echo -e "(请直接填目录名(相对路径)): \c"
                read value_dir

            fi

        fi

        #进入解压之后的目录开始配置编译安装
        cd $VIM_CFG_DIR/$value_dir
        $CONFIG $CFG_ARGS $CFG_OTHER_ARGS
        $MAKE $MKARGS
        $MAKE $MKINSTALL

        #安装完成一个就清除目录和临时文件并为下一个安装做准备
        cd $VIM_CFG_DIR
        $DEL_DIR $TEMP_FILE
        $DEL_DIR $VIM_CFG_DIR/$value_dir
    done

    $DEL_DIR $VIM_CFG_DIR/*.tar.gz
    return 0
}

function source_tar_bz2_plugin()
{
    echo "function source_tar_bz2_plugin()>>>*.tar.bz2  script plugins"
    return 0
}

function source_tar_plugin()
{
    echo "function source_tar_plugin()>>>*.tar  script plugins"

    return 0
}
function source_zip_plugin()
{
    echo "function source_zip_plugin()>>>*.zip  script plugins"
    return 0
}

#安装  script plugins
function source_plugin()
{
    echo "function source_plugin()>>>  script plugins"
    if [ $HOSTOS == "ubuntu" ] ;
    then
        host www.baidu.com 1>/dev/null 2>/dev/null
        if [ $? -ne 0 ] ;
        then
            echo "Error: Network unavailable!"
            echo "       Install with local source package!"
            cd $CURRENT_DIR/plugin/source && \
                tar -xzvf $cscope_src_package && \
                cd $cscope_src_git && \
                ./configure --prefix=/usr && \
                make && $SUDO make install && \
                cd .. && rm -rf $cscope_src_git

            cd $CURRENT_DIR/plugin/source && \
                tar -xzvf $ctags_src_package && \
                cd $ctags_src_git && \
                ./configure --prefix=/usr && \
                make && $SUDO make install && \
                cd .. && rm -rf $ctags_src_git
            return 0
        fi
        $SUDO apt-get install -y ctags
        $SUDO apt-get install -y cscope
        $SUDO apt-get install -y cscope-el
        $SUDO apt-get install -y exuberant-ctags
        return 0
    fi

    #Redhat CentOS
    host www.baidu.com 1>/dev/null 2>/dev/null
    if [ $? -ne 0 ] ;
    then
        echo "Error: Network unavailable!"
        echo "       Install with local source package!"
        cd $CURRENT_DIR/plugin/source && \
            tar -xzvf $cscope_src_package && \
            cd $cscope_src_git && \
            ./configure --prefix=/usr && \
            make && $SUDO make install && \
            cd .. && rm -rf $cscope_src_git

        cd $CURRENT_DIR/plugin/source && \
            tar -xzvf $ctags_src_package && \
            cd $ctags_src_git && \
            ./configure --prefix=/usr && \
            make && $SUDO make install && \
            cd .. && rm -rf $cscope_src_git
        return 0
    fi
    $SUDO yum install -y ctags
    $SUDO yum install -y ctags-etags
    $SUDO yum install -y cscope
    $SUDO yum install -y cscope-el
    $SUDO yum install -y exuberant-ctags

    return 0
}

function script_plugin()
{
    echo "function script_plugin()>>> script plugins"
    rm -rf $HOME/.vim/*
    mkdir -p $HOME/.vim
    src_dir=$1    #$SCRIPTS_DIR
    dst_dir=$2    #$HOME/.vim
    #local dst_dir=$CURRENT_DIR/others
    ls $src_dir/*.tar.gz 2>/dev/null 1>/dev/null
    if [ $? -eq 0 ]
    then
        ls $src_dir/*.tar.gz | xargs -i -d "\n" tar -xzvf {} -C $dst_dir
        ls -shl $src_dir/*.tar.gz
    fi

    ls $src_dir/*.tar.bz2  2>/dev/null 1>/dev/null
    if [ $? -eq 0 ]
    then
        ls $src_dir/*.tar.bz2 | xargs -i -d "\n" tar -xjvf {} -C $dst_dir
        ls -shl $src_dir/*.tar.bz2
    fi

    ls $src_dir/*.tar 2>/dev/null 1>/dev/null
    if [ $? -eq 0 ]
    then
        ls $src_dir/*.tar | xargs -i -d "\n" tar -xvf {} -C $dst_dir
        ls -shl $src_dir/*.tar
    fi

    ls $src_dir/*.zip 2>/dev/null 1>/dev/null
    if [ $? -eq 0 ]
    then
        ls $src_dir/*.zip | xargs -i -d "\n" unzip {} -d $dst_dir
        ls -shl $src_dir/*.zip
    fi

    ls $src_dir/*.vim 2>/dev/null 1>/dev/null
    if [ $? -eq 0 ]
    then
        cp -v $src_dir/*.vim $dst_dir/plugin
        ls -shl $src_dir/*.vim
    fi
    return 0
}

#Install plugins(both source and script)"
function install_plugin()
{
    echo "function install_plugin()>>>Install plugins(both source and script)"
    script_plugin $SCRIPTS_DIR $HOME/.vim  #安装一些无法git获取plg
    source_plugin
    return 0
}

#Install vimtool/config/object.sh configuration files"
function config_object()
{
    echo "function config_object()>>>Install object configuration files"
    $SUDO cp -v $VIMTOOL_CONFIG/$OBJECT_TOOL $OBJECT_TOOL_PATH
    $SUDO chmod 755 /usr/bin/object.sh
    return 0
}

#Install 'vimtool/config/vimrc' configuration file"
function config_vimrc()
{
    echo "function config_vimrc()>>>Install vimrc configuration file"
    echo "function config_vimrc()>>>Install vimrc configuration file"
    #cat $CURRENT_DIR/config/$VIMRC > $HOME/.vimrc
    cp -v $CURRENT_DIR/config/$VIMRC $HOME/.vimrc
    echo -e "Please input your name: \c"
    read user_name
    echo -e "Please input your email: \c"
    read user_email
	
    echo "let g:header_field_author = '${user_name}'" >> ~/.vimrc
    echo "let g:header_field_author_email = '${user_email}'" >> ~/.vimrc
	
	if [ $HOSTOS == "ubuntu" ] ;
	then
		sed -i '/colorscheme/d' ~/.vimrc
	fi

    return 0
}

#Install configuration files"
function install_config()
{
    echo "function install_config()>>>Install configuration files"
    config_object
    config_vimrc
}

#Don't install vim"
function no_vim()
{
    echo "function no_vim()>>>Dont install vim"
    CUR=`pwd`
    echo "CUR: $CUR"
    install_plugin
    return 0
}

#Install vim"
function install_vim()
{
    echo "function install_vim()>>>Install vim"
    only_vim
    return 0
}

#Complete installation function
function complete_install()
{
    echo "function complete_install()>>>Complete installation function"
    install_vim             #step01 install vim editor
    install_plugin          #step02 install plugin
    install_config          #step03 install configuration file
}

function build_vimconf_dir()
{
    mkdir -p $VIM_CFG_DIR 1>/dev/null 2>/dev/null
    mkdir -p $VIM_CFG_DIR_PLUGIN 1>/dev/null 2>/dev/null
    mkdir -p $VIM_CFG_DIR_AUTOLOAD 1>/dev/null 2>/dev/null
    mkdir -p $VIM_CFG_DIR_DOC 1>/dev/null 2>/dev/null
    return 0
}

#The main function(entry)
function install_vimtool()
{


    echo "function install_vimtool()>>>安装主函数"
    if [ $UID -ne 0 ] ;
    then
        echo "You had better to run build_all as a root user"
        echo "Press Enter to continue..."
        SUDO=sudo
    fi

    INSTALL_ARG=$1
	
	case $INSTALL_ARG in 
		"")
			echo "Complete installation"
			$DEL_DIR $VIM_CFG_DIR
			build_vimconf_dir
			complete_install
			vimtool_finish
			;;
		"only_vim" | "vim" | "vi")
			echo "Only install vim editor"
            only_vim
            vimtool_finish
			;;
		"no_vim")
			echo "Only install plugins (both script and source)"
            $DEL_DIR $VIM_CFG_DIR
            build_vimconf_dir
            no_vim
            vimtool_finish
			;;
		"script_plugin" | "scr_plg")
			echo "Only install  script plugins"
            script_plugin $SCRIPTS_DIR $HOME/.vim  #安装一些无法git获取plg
            vimtool_finish
			;;
		"source_plugin" | "src_plg")
			echo "Only install source code plugins"
            source_plugin
            vimtool_finish
			;;
		"update_config" | "config" | "cfg" | "vimrc")
			echo "Only update configuration files"
            install_config
            vimtool_finish
			;;
		"help" | "?" | "-H" | "-h" | "/?")
			echo "Display installation information:"
            build_all_help
			;;
		*)
			echo "ERROR: $INSTALL_ARG unknown argument!!!"
            echo "Press <Enter> to continue ..."
            read temporary
            build_all_help
			;;
	esac

    return 0
}

#-----------------------------------------------
#开发调试部分
#---------------------------------------------
#echo "VIM_CONFIG: ${VIM_CONFIG[*]}"
#echo "configlen: ${#VIM_CONFIG[*]}"
#debug_vimtool           #类似断点:只能执行这个之上代码
#----------------------------------------------


#--------------------------------------------------
#函数执行部分
#-------------------------------------------------
install_vimtool $1      #help, only_vim, source_plugin, update_config, etc.
#--------------------------------------------------
#script_plugin
#config_vimrc
