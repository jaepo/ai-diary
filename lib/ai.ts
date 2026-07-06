import Anthropic from "@anthropic-ai/sdk";

const anthropic = new Anthropic({
  apiKey: process.env.ANTHROPIC_API_KEY,
});

export interface DiaryAnalysis {
  sentiment: "positive" | "negative" | "neutral";
  sentimentScore: number;
  aiResponse: string;
  keywords: string[];
}

export async function analyzeDiary(content: string): Promise<DiaryAnalysis> {
  const prompt = `다음은 사용자가 작성한 일기입니다. 이 일기를 분석하여 다음 정보를 JSON 형식으로 반환해주세요:

1. sentiment: 전체적인 감정 ("positive", "negative", "neutral" 중 하나)
2. sentimentScore: -1.0(매우 부정)부터 1.0(매우 긍정) 사이의 점수
3. aiResponse: 사용자에게 전할 위로와 응원의 메시지 (2-3문장)
   - 빌 브라이슨(Bill Bryson, '거의 모든 것의 역사' 저자)의 어투로 작성
   - 유머러스하고 재치있게, 하지만 따뜻하게
   - 일상의 작은 것들에서 경이로움을 찾는 브라이슨 특유의 관점
   - 과학적/역사적 사실을 곁들인 위트있는 격려
   - 한국어로 작성하되, 브라이슨의 영국식 유머 감각 유지
4. keywords: 일기의 주요 키워드 5개 (배열 형태)

일기 내용:
"""
${content}
"""

JSON 형식으로만 응답해주세요.`;

  try {
    const message = await anthropic.messages.create({
      model: "claude-sonnet-4-5",
      max_tokens: 1024,
      messages: [
        {
          role: "user",
          content: prompt,
        },
      ],
    });

    const responseText =
      message.content[0].type === "text" ? message.content[0].text : "";

    // JSON 파싱
    const jsonMatch = responseText.match(/\{[\s\S]*\}/);
    if (!jsonMatch) {
      throw new Error("Invalid JSON response from AI");
    }

    const analysis = JSON.parse(jsonMatch[0]) as DiaryAnalysis;
    return analysis;
  } catch (error) {
    console.error("AI analysis error:", error);
    // 기본 응답 반환 (브라이슨 스타일)
    return {
      sentiment: "neutral",
      sentimentScore: 0,
      aiResponse: "놀랍게도, 당신이 지금 이 순간에도 숨을 쉬고 있다는 사실 자체가 우주적 관점에서 보면 경이로운 일입니다. 오늘도 이 기적을 이어가셨군요!",
      keywords: ["일기"],
    };
  }
}
