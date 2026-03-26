#!/bin/bash
# 圆桌会议 Skill 安装脚本
# 用法: bash setup.sh [项目目录]

set -e

PROJECT_DIR="${1:-.}"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  集团圆桌会议 Skill 安装"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# 1. 安装 Skill 文件
SKILL_DIR="$PROJECT_DIR/.claude/skills"
mkdir -p "$SKILL_DIR"
cp "$(dirname "$0")/roundtable.md" "$SKILL_DIR/roundtable.md"
echo "✅ Skill 文件已安装到 $SKILL_DIR/roundtable.md"

# 2. 创建圆桌会议数据目录
RT_DIR="$PROJECT_DIR/roundtable"
mkdir -p "$RT_DIR/minutes"
mkdir -p "$RT_DIR/roles"
echo "✅ 圆桌数据目录已创建: $RT_DIR/"

# 3. 复制扩展角色
SCRIPT_DIR="$(dirname "$0")"
if [ -d "$SCRIPT_DIR/setup/roles" ]; then
    cp "$SCRIPT_DIR/setup/roles/"*.md "$RT_DIR/roles/" 2>/dev/null || true
    echo "✅ 扩展角色已安装:"
    for f in "$RT_DIR/roles/"*.md; do
        [ -f "$f" ] && echo "   ▸ $(basename "$f" .md)"
    done
fi

# 4. 创建 .gitignore（保护敏感信息）
if [ ! -f "$RT_DIR/.gitignore" ]; then
    cat > "$RT_DIR/.gitignore" << 'EOF'
# 公司档案和会议纪要可能包含敏感信息
company-profile.md
minutes/
action-tracker.md
# 角色定义可以提交
!roles/
EOF
    echo "✅ .gitignore 已创建（保护敏感文件）"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  安装完成！"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "使用方法："
echo "  在 Claude Code 中输入："
echo "    /roundtable 门店店长绩效怎么考核"
echo "    /roundtable"
echo ""
echo "首次使用会进入公司信息对齐流程。"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
