#!/bin/bash
# AI Tech Daily - 自动抓取并生成文章框架
# 使用 GitHub API 搜索最新 AI/LLM 项目

REPO_DIR="$HOME/clawd/ai-tech-daily"
DATE=$(date +%Y-%m-%d)
OUTPUT_FILE="$REPO_DIR/$DATE-ai-tech-daily.md"

# GitHub API 搜索
API_RESULTS=$(curl -s "https://api.github.com/search/repositories?q=AI+LLM+GPT+Claude+Gemini&sort=updated&per_page=15" | jq '.items[] | {name: .full_name, desc: .description, updated: .updated_at, url: .html_url, stars: .stargazers_count}')

# OpenAI SDK releases
OPENAI_RELEASE=$(curl -s "https://api.github.com/repos/openai/openai-python/releases/latest" | jq '{name: .name, published: .published_at, notes: .body[:500]}')

# Anthropic commits
ANTHROPIC_COMMITS=$(curl -s "https://api.github.com/repos/anthropics/anthropic-sdk-python/commits?per_page=5" | jq '.[].commit.message')

# Agent framework search
AGENT_RESULTS=$(curl -s "https://api.github.com/search/repositories?q=AI+agent+framework+2026&sort=updated&per_page=10" | jq '.items[] | {name: .full_name, desc: .description, stars: .stargazers_count}')

# 输出素材文件（供 agent 撰写）
echo "# $DATE AI Tech Daily素材" > "$REPO_DIR/materials/$DATE-raw.json"
mkdir -p "$REPO_DIR/materials"

cat > "$REPO_DIR/materials/$DATE-raw.json" << EOF
{
  "date": "$DATE",
  "llm_projects": $API_RESULTS,
  "openai_release": $OPENAI_RELEASE,
  "anthropic_commits": $ANTHROPIC_COMMITS,
  "agent_frameworks": $AGENT_RESULTS
}
EOF

echo "素材已保存到 $REPO_DIR/materials/$DATE-raw.json"
echo "请用 agent 撰写文章并推送"