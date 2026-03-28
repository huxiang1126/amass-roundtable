#!/bin/bash
# 圆桌会议 Skill v1.1 安装脚本（Agent Teams 版）
# 用法: bash amass-roundtable/setup.sh /你想安装的路径

set -e

PROJECT_DIR="${1:-.}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  集团圆桌会议 v1.1 安装"
echo "  Agent Teams 驱动"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# 1. 创建项目目录
mkdir -p "$PROJECT_DIR"
echo "✅ 项目目录: $PROJECT_DIR"

# 2. 安装 Skill 文件
SKILL_DIR="$PROJECT_DIR/.claude/skills/roundtable"
mkdir -p "$SKILL_DIR"
cp "$SCRIPT_DIR/roundtable.md" "$SKILL_DIR/SKILL.md"
echo "✅ Skill 已安装: .claude/skills/roundtable/SKILL.md"

# 3. 开启 Agent Teams 功能
SETTINGS_DIR="$PROJECT_DIR/.claude"
SETTINGS_FILE="$SETTINGS_DIR/settings.json"
if [ -f "$SETTINGS_FILE" ]; then
    # 如果已有 settings.json，检查是否已配置
    if grep -q "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS" "$SETTINGS_FILE" 2>/dev/null; then
        echo "✅ Agent Teams 已配置"
    else
        echo "⚠️  检测到已有 settings.json，请手动添加以下配置:"
        echo '   "env": { "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1" }'
    fi
else
    cat > "$SETTINGS_FILE" << 'EOF'
{
  "env": {
    "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1"
  }
}
EOF
    echo "✅ Agent Teams 已开启: .claude/settings.json"
fi

# 4. 创建圆桌会议数据目录 + 复制角色文件
RT_DIR="$PROJECT_DIR/roundtable"
mkdir -p "$RT_DIR/minutes"
mkdir -p "$RT_DIR/roles"

if [ -d "$SCRIPT_DIR/setup/roles" ]; then
    cp "$SCRIPT_DIR/setup/roles/"*.md "$RT_DIR/roles/" 2>/dev/null || true
fi
echo "✅ 角色库已安装:"
for f in "$RT_DIR/roles/"*.md; do
    [ -f "$f" ] && echo "   ▸ $(basename "$f" .md)"
done

# 5. 创建 .gitignore
if [ ! -f "$RT_DIR/.gitignore" ]; then
    cat > "$RT_DIR/.gitignore" << 'EOF'
# 公司档案和会议纪要可能包含敏感信息
company-profile.md
minutes/
action-tracker.md
# 角色定义可以提交
!roles/
EOF
    echo "✅ .gitignore 已创建"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  安装完成！"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "使用方法："
echo ""
echo "  1. 打开 Claude Code 桌面应用"
echo "  2. 选择项目目录: $PROJECT_DIR"
echo "  3. 输入: /roundtable 你想讨论的议题"
echo ""
echo "首次使用会进入公司信息对齐流程。"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
