import { NextRequest, NextResponse } from "next/server";
import { auth } from "@/auth";
import { prisma } from "@/lib/db";
import { analyzeDiary } from "@/lib/ai";

// GET: 일기 목록 조회
export async function GET() {
  try {
    const session = await auth();

    if (!session?.user?.id) {
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }

    const entries = await prisma.diaryEntry.findMany({
      where: { userId: session.user.id },
      orderBy: { createdAt: "desc" },
      take: 20,
    });

    // keywords를 JSON 파싱
    const entriesWithParsedKeywords = entries.map(entry => ({
      ...entry,
      keywords: entry.keywords ? JSON.parse(entry.keywords) : [],
    }));

    return NextResponse.json(entriesWithParsedKeywords);
  } catch (error) {
    console.error("GET /api/diary error:", error);
    return NextResponse.json(
      { error: "Failed to fetch diary entries" },
      { status: 500 }
    );
  }
}

// POST: 새 일기 작성
export async function POST(request: NextRequest) {
  try {
    const session = await auth();

    if (!session?.user?.id) {
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }

    const { content } = await request.json();

    if (!content || typeof content !== "string" || content.trim().length === 0) {
      return NextResponse.json(
        { error: "Content is required" },
        { status: 400 }
      );
    }

    // AI 분석 실행
    const analysis = await analyzeDiary(content);

    // DB에 저장
    const entry = await prisma.diaryEntry.create({
      data: {
        userId: session.user.id,
        content: content.trim(),
        sentiment: analysis.sentiment,
        sentimentScore: analysis.sentimentScore,
        aiResponse: analysis.aiResponse,
        keywords: JSON.stringify(analysis.keywords),
      },
    });

    return NextResponse.json({
      ...entry,
      keywords: JSON.parse(entry.keywords || "[]"),
    });
  } catch (error) {
    console.error("POST /api/diary error:", error);
    return NextResponse.json(
      { error: "Failed to create diary entry" },
      { status: 500 }
    );
  }
}
