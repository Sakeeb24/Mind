import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mindspace/config/theme.dart';
import 'package:mindspace/features/dashboard/domain/entities/document.dart';
import 'package:mindspace/features/document_viewer/presentation/providers/canvas_provider.dart';
import 'package:mindspace/providers/ai_service_provider.dart';
import 'package:mindspace/services/ai/ai_service.dart';

class StudyFeaturesDialogs {
  StudyFeaturesDialogs._();

  // ────────────────────────────────────────────────────────────
  // 1. KEY FORMULAS & DEFINITIONS
  // ────────────────────────────────────────────────────────────
  static void showFormulasDialog({
    required BuildContext context,
    required WidgetRef ref,
    required Document document,
    int? currentPage,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _FormulasBottomSheet(
        document: document,
        currentPage: currentPage,
      ),
    );
  }

  // ────────────────────────────────────────────────────────────
  // 2. GENERATE 5 FLASHCARDS
  // ────────────────────────────────────────────────────────────
  static void showFlashcardsDialog({
    required BuildContext context,
    required WidgetRef ref,
    required Document document,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _FlashcardsBottomSheet(
        document: document,
      ),
    );
  }

  // ────────────────────────────────────────────────────────────
  // 3. QUIZ ME
  // ────────────────────────────────────────────────────────────
  static void showQuizDialog({
    required BuildContext context,
    required WidgetRef ref,
    required Document document,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _QuizBottomSheet(
        document: document,
      ),
    );
  }

  // ────────────────────────────────────────────────────────────
  // 4. SUMMARIZE DOC / PAGE
  // ────────────────────────────────────────────────────────────
  static void showSummaryDialog({
    required BuildContext context,
    required WidgetRef ref,
    required Document document,
    int? currentPage,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _SummaryBottomSheet(
        document: document,
        currentPage: currentPage,
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────
// FORMULAS BOTTOM SHEET WIDGET
// ────────────────────────────────────────────────────────────
class _FormulasBottomSheet extends ConsumerStatefulWidget {
  const _FormulasBottomSheet({
    required this.document,
    this.currentPage,
  });

  final Document document;
  final int? currentPage;

  @override
  ConsumerState<_FormulasBottomSheet> createState() => _FormulasBottomSheetState();
}

class _FormulasBottomSheetState extends ConsumerState<_FormulasBottomSheet> {
  bool _isLoading = true;
  String? _error;
  List<FormulaDefinition> _formulas = [];

  @override
  void initState() {
    super.initState();
    _loadFormulas();
  }

  Future<void> _loadFormulas() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final aiService = ref.read(aiServiceProvider);
      final docContext = 'Document: ${widget.document.title}\nPage ${widget.currentPage ?? 1} of ${widget.document.pageCount}';
      final result = await aiService.extractFormulasAndDefinitions(
        documentText: docContext,
        pageNumber: widget.currentPage,
      );
      if (mounted) {
        setState(() {
          _formulas = result;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to extract formulas. Please try again.';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: MediaQuery.of(context).size.height * 0.78,
      decoration: BoxDecoration(
        color: isDark ? AppColors.navySlate : AppColors.lightSurface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border.all(
          color: isDark ? AppColors.whisperBorderBright : AppColors.lightDivider,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Drag Handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? Colors.white24 : Colors.black12,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.success.withAlpha(isDark ? 35 : 20),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.calculate_outlined, color: AppColors.success, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Key Formulas & Definitions',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        ),
                      ),
                      Text(
                        widget.document.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Content Body
          Expanded(
            child: _isLoading
                ? const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(color: AppColors.cyanGlow),
                        SizedBox(height: 16),
                        Text('Extracting formulas & definitions with AI...'),
                      ],
                    ),
                  )
                : _error != null
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.error_outline, color: AppColors.error, size: 36),
                            const SizedBox(height: 12),
                            Text(_error!),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: _loadFormulas,
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _formulas.length,
                        itemBuilder: (context, index) {
                          final item = _formulas[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 14),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.surfaceContainerLow
                                  : AppColors.lightSurfaceVariant,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: isDark ? AppColors.whisperBorder : AppColors.lightDivider,
                                width: 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: AppColors.success.withAlpha(isDark ? 30 : 20),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        item.type.toUpperCase(),
                                        style: GoogleFonts.jetBrainsMono(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.success,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        item.title,
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                        ),
                                      ),
                                    ),
                                    if (item.pageNumber != null)
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: isDark ? AppColors.surfaceContainerHigh : Colors.white,
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          'p. ${item.pageNumber}',
                                          style: GoogleFonts.jetBrainsMono(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 10),

                                // Formula Box
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: isDark ? const Color(0xFF0F172A) : const Color(0xFFE2E8F0),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: SelectableText(
                                    item.formulaOrDefinition,
                                    style: GoogleFonts.jetBrainsMono(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: isDark ? AppColors.cyanGlow : const Color(0xFF1E293B),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 8),
                                Text(
                                  item.explanation,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12.5,
                                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                    height: 1.4,
                                  ),
                                ),

                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    OutlinedButton.icon(
                                      icon: const Icon(Icons.send_rounded, size: 14),
                                      label: const Text('Send to Canvas', style: TextStyle(fontSize: 12)),
                                      style: OutlinedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                        minimumSize: const Size(0, 32),
                                      ),
                                      onPressed: () {
                                        ref.read(canvasProvider.notifier).addConceptCard(
                                              documentId: widget.document.id,
                                              title: item.title,
                                              content: '${item.formulaOrDefinition}\n\n${item.explanation}',
                                              pageNumber: item.pageNumber ?? widget.currentPage ?? 1,
                                            );
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('Added "${item.title}" to Study Canvas'),
                                            behavior: SnackBarBehavior.floating,
                                            duration: const Duration(seconds: 2),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────
// FLASHCARDS BOTTOM SHEET WIDGET
// ────────────────────────────────────────────────────────────
class _FlashcardsBottomSheet extends ConsumerStatefulWidget {
  const _FlashcardsBottomSheet({required this.document});
  final Document document;

  @override
  ConsumerState<_FlashcardsBottomSheet> createState() => _FlashcardsBottomSheetState();
}

class _FlashcardsBottomSheetState extends ConsumerState<_FlashcardsBottomSheet> {
  bool _isLoading = true;
  String? _error;
  List<FlashcardItem> _flashcards = [];
  int _currentIndex = 0;
  bool _showAnswer = false;

  @override
  void initState() {
    super.initState();
    _loadFlashcards();
  }

  Future<void> _loadFlashcards() async {
    setState(() {
      _isLoading = true;
      _error = null;
      _currentIndex = 0;
      _showAnswer = false;
    });

    try {
      final aiService = ref.read(aiServiceProvider);
      final docContext = 'Document: ${widget.document.title}\nPages: ${widget.document.pageCount}';
      final cards = await aiService.generateFlashcards(
        documentText: docContext,
        count: 5,
      );
      if (mounted) {
        setState(() {
          _flashcards = cards;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _error = 'Failed to generate flashcards.';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: MediaQuery.of(context).size.height * 0.78,
      decoration: BoxDecoration(
        color: isDark ? AppColors.navySlate : AppColors.lightSurface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border.all(
          color: isDark ? AppColors.whisperBorderBright : AppColors.lightDivider,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Drag Handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? Colors.white24 : Colors.black12,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.electricIndigo.withAlpha(isDark ? 35 : 20),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.style_outlined, color: AppColors.electricIndigo, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Active-Recall Flashcards (5 Cards)',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        ),
                      ),
                      Text(
                        widget.document.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Body
          Expanded(
            child: _isLoading
                ? const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(color: AppColors.electricIndigo),
                        SizedBox(height: 16),
                        Text('Generating 5 active-recall flashcards...'),
                      ],
                    ),
                  )
                : _error != null || _flashcards.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.error_outline, color: AppColors.error, size: 36),
                            const SizedBox(height: 12),
                            Text(_error ?? 'No flashcards generated'),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: _loadFlashcards,
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            // Progress bar
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Card ${_currentIndex + 1} of ${_flashcards.length}',
                                  style: GoogleFonts.jetBrainsMono(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                  ),
                                ),
                                if (_flashcards[_currentIndex].keyConcept != null)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withAlpha(25),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      _flashcards[_currentIndex].keyConcept!,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: (_currentIndex + 1) / _flashcards.length,
                                minHeight: 4,
                                backgroundColor: isDark ? Colors.white12 : Colors.black12,
                                color: AppColors.electricIndigo,
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Flashcard Box
                            Expanded(
                              child: GestureDetector(
                                onTap: () => setState(() => _showAnswer = !_showAnswer),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(24),
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? AppColors.surfaceContainerLow
                                        : AppColors.lightSurfaceVariant,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: _showAnswer
                                          ? AppColors.cyanGlow
                                          : (isDark ? AppColors.whisperBorder : AppColors.lightDivider),
                                      width: _showAnswer ? 1.5 : 1,
                                    ),
                                    boxShadow: AppDecorations.softShadow,
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            _showAnswer ? 'ANSWER' : 'QUESTION',
                                            style: GoogleFonts.jetBrainsMono(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w700,
                                              letterSpacing: 1,
                                              color: _showAnswer
                                                  ? AppColors.cyanGlow
                                                  : AppColors.primary,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.touch_app_outlined,
                                                size: 14,
                                                color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                'Tap to flip',
                                                style: GoogleFonts.plusJakartaSans(
                                                  fontSize: 11,
                                                  color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                      Expanded(
                                        child: SingleChildScrollView(
                                          child: Text(
                                            _showAnswer
                                                ? _flashcards[_currentIndex].answer
                                                : _flashcards[_currentIndex].question,
                                            style: GoogleFonts.plusJakartaSans(
                                              fontSize: 16,
                                              height: 1.5,
                                              fontWeight: _showAnswer ? FontWeight.w400 : FontWeight.w600,
                                              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Controls Row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton.outlined(
                                  icon: const Icon(Icons.chevron_left_rounded),
                                  onPressed: _currentIndex > 0
                                      ? () => setState(() {
                                            _currentIndex--;
                                            _showAnswer = false;
                                          })
                                      : null,
                                ),
                                OutlinedButton.icon(
                                  icon: const Icon(Icons.send_rounded, size: 14),
                                  label: const Text('Add to Canvas', style: TextStyle(fontSize: 12)),
                                  onPressed: () {
                                    final card = _flashcards[_currentIndex];
                                    ref.read(canvasProvider.notifier).addConceptCard(
                                          documentId: widget.document.id,
                                          title: 'Q: ${card.question}',
                                          content: 'A: ${card.answer}',
                                          pageNumber: card.pageNumber ?? 1,
                                        );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Flashcard placed on Study Canvas'),
                                        behavior: SnackBarBehavior.floating,
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                  },
                                ),
                                IconButton.outlined(
                                  icon: const Icon(Icons.chevron_right_rounded),
                                  onPressed: _currentIndex < _flashcards.length - 1
                                      ? () => setState(() {
                                            _currentIndex++;
                                            _showAnswer = false;
                                          })
                                      : null,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────
// QUIZ BOTTOM SHEET WIDGET
// ────────────────────────────────────────────────────────────
class _QuizBottomSheet extends ConsumerStatefulWidget {
  const _QuizBottomSheet({required this.document});
  final Document document;

  @override
  ConsumerState<_QuizBottomSheet> createState() => _QuizBottomSheetState();
}

class _QuizBottomSheetState extends ConsumerState<_QuizBottomSheet> {
  bool _isLoading = true;
  String? _error;
  List<QuizQuestionItem> _questions = [];
  int _currentIndex = 0;
  int? _selectedOption;
  bool _isAnswerSubmitted = false;
  int _score = 0;
  bool _isFinished = false;

  @override
  void initState() {
    super.initState();
    _loadQuiz();
  }

  Future<void> _loadQuiz() async {
    setState(() {
      _isLoading = true;
      _error = null;
      _currentIndex = 0;
      _selectedOption = null;
      _isAnswerSubmitted = false;
      _score = 0;
      _isFinished = false;
    });

    try {
      final aiService = ref.read(aiServiceProvider);
      final docContext = 'Document: ${widget.document.title}\nPages: ${widget.document.pageCount}';
      final qs = await aiService.generateQuiz(
        documentText: docContext,
        questionCount: 5,
      );
      if (mounted) {
        setState(() {
          _questions = qs;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _error = 'Failed to generate quiz questions.';
          _isLoading = false;
        });
      }
    }
  }

  void _submitAnswer() {
    if (_selectedOption == null) return;
    final currentQ = _questions[_currentIndex];
    final isCorrect = _selectedOption == currentQ.correctIndex;
    setState(() {
      _isAnswerSubmitted = true;
      if (isCorrect) _score++;
    });
  }

  void _nextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedOption = null;
        _isAnswerSubmitted = false;
      });
    } else {
      setState(() {
        _isFinished = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: MediaQuery.of(context).size.height * 0.82,
      decoration: BoxDecoration(
        color: isDark ? AppColors.navySlate : AppColors.lightSurface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border.all(
          color: isDark ? AppColors.whisperBorderBright : AppColors.lightDivider,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Drag Handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? Colors.white24 : Colors.black12,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.cyanGlow.withAlpha(isDark ? 35 : 20),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.quiz_outlined, color: AppColors.cyanGlow, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Document Quiz Studio',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        ),
                      ),
                      Text(
                        widget.document.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Body
          Expanded(
            child: _isLoading
                ? const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(color: AppColors.cyanGlow),
                        SizedBox(height: 16),
                        Text('Synthesizing grounded quiz questions...'),
                      ],
                    ),
                  )
                : _error != null || _questions.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.error_outline, color: AppColors.error, size: 36),
                            const SizedBox(height: 12),
                            Text(_error ?? 'No questions available'),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: _loadQuiz,
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      )
                    : _isFinished
                        ? _buildQuizSummary(isDark)
                        : _buildQuestionView(isDark),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionView(bool isDark) {
    final currentQ = _questions[_currentIndex];

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question Progress
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Question ${_currentIndex + 1} of ${_questions.length}',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.cyanGlow : AppColors.primary,
                ),
              ),
              Text(
                'Score: $_score / ${_currentIndex + (_isAnswerSubmitted ? 1 : 0)}',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: (_currentIndex + 1) / _questions.length,
              minHeight: 4,
              backgroundColor: isDark ? Colors.white12 : Colors.black12,
              color: AppColors.cyanGlow,
            ),
          ),

          const SizedBox(height: 16),

          // Question Text
          Text(
            currentQ.question,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              height: 1.35,
            ),
          ),

          const SizedBox(height: 16),

          // Options List
          Expanded(
            child: ListView.builder(
              itemCount: currentQ.options.length,
              itemBuilder: (context, index) {
                final optionText = currentQ.options[index];
                final isSelected = _selectedOption == index;
                final isCorrectOption = index == currentQ.correctIndex;

                Color borderColor = isDark ? AppColors.whisperBorder : AppColors.lightDivider;
                Color bgColor = isDark ? AppColors.surfaceContainerLow : AppColors.lightSurfaceVariant;

                if (_isAnswerSubmitted) {
                  if (isCorrectOption) {
                    borderColor = AppColors.success;
                    bgColor = AppColors.success.withAlpha(isDark ? 30 : 20);
                  } else if (isSelected) {
                    borderColor = AppColors.error;
                    bgColor = AppColors.error.withAlpha(isDark ? 30 : 20);
                  }
                } else if (isSelected) {
                  borderColor = AppColors.cyanGlow;
                  bgColor = AppColors.cyanGlow.withAlpha(isDark ? 25 : 15);
                }

                return GestureDetector(
                  onTap: _isAnswerSubmitted
                      ? null
                      : () => setState(() => _selectedOption = index),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: borderColor, width: isSelected || (_isAnswerSubmitted && isCorrectOption) ? 1.5 : 1),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 26,
                          height: 26,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected ? borderColor : Colors.transparent,
                            border: Border.all(color: borderColor, width: 1.2),
                          ),
                          child: Center(
                            child: Text(
                              String.fromCharCode(65 + index),
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: isSelected ? Colors.white : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            optionText,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                            ),
                          ),
                        ),
                        if (_isAnswerSubmitted && isCorrectOption)
                          const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 18)
                        else if (_isAnswerSubmitted && isSelected && !isCorrectOption)
                          const Icon(Icons.cancel_rounded, color: AppColors.error, size: 18),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Explanation Banner (when submitted)
          if (_isAnswerSubmitted)
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF0F172A) : const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isDark ? AppColors.whisperBorder : AppColors.lightDivider,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _selectedOption == currentQ.correctIndex ? '✓ Correct!' : '✗ Explanation:',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: _selectedOption == currentQ.correctIndex
                          ? AppColors.success
                          : AppColors.error,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    currentQ.explanation,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                  ),
                ],
              ),
            ),

          // Action Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _selectedOption == null
                  ? null
                  : _isAnswerSubmitted
                      ? _nextQuestion
                      : _submitAnswer,
              child: Text(
                _isAnswerSubmitted
                    ? (_currentIndex < _questions.length - 1 ? 'Next Question' : 'View Results')
                    : 'Submit Answer',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizSummary(bool isDark) {
    final percent = (_score / _questions.length * 100).toInt();

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: (percent >= 70 ? AppColors.success : AppColors.warning)
                    .withAlpha(isDark ? 35 : 20),
              ),
              child: Icon(
                percent >= 70 ? Icons.emoji_events_rounded : Icons.psychology_rounded,
                size: 48,
                color: percent >= 70 ? AppColors.success : AppColors.warning,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Quiz Completed!',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'You scored $_score out of ${_questions.length} ($percent%)',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: percent >= 70 ? AppColors.success : AppColors.warning,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton.icon(
                  onPressed: _loadQuiz,
                  icon: const Icon(Icons.refresh_rounded, size: 16),
                  label: const Text('Retry Quiz'),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.check_rounded, size: 16),
                  label: const Text('Done'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────
// SUMMARY BOTTOM SHEET WIDGET
// ────────────────────────────────────────────────────────────
class _SummaryBottomSheet extends ConsumerStatefulWidget {
  const _SummaryBottomSheet({
    required this.document,
    this.currentPage,
  });

  final Document document;
  final int? currentPage;

  @override
  ConsumerState<_SummaryBottomSheet> createState() => _SummaryBottomSheetState();
}

class _SummaryBottomSheetState extends ConsumerState<_SummaryBottomSheet> {
  bool _isLoading = true;
  String? _error;
  String _summaryContent = '';
  String _scope = 'document';

  @override
  void initState() {
    super.initState();
    _scope = widget.currentPage != null ? 'page' : 'document';
    _loadSummary();
  }

  Future<void> _loadSummary() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final aiService = ref.read(aiServiceProvider);
      final docContext = 'Document: ${widget.document.title}\nPage ${widget.currentPage ?? 1} of ${widget.document.pageCount}';
      final result = await aiService.summarize(
        documentText: docContext,
        scope: _scope,
        pageNumber: widget.currentPage,
      );
      if (mounted) {
        setState(() {
          _summaryContent = result;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _error = 'Failed to generate summary. Please try again.';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: MediaQuery.of(context).size.height * 0.78,
      decoration: BoxDecoration(
        color: isDark ? AppColors.navySlate : AppColors.lightSurface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border.all(
          color: isDark ? AppColors.whisperBorderBright : AppColors.lightDivider,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Drag Handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? Colors.white24 : Colors.black12,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withAlpha(isDark ? 35 : 20),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.summarize_outlined, color: AppColors.primary, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _scope == 'page' ? 'Page ${widget.currentPage} Summary' : 'Document Summary',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        ),
                      ),
                      Text(
                        widget.document.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Scope Switcher
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SegmentedButton<String>(
              segments: [
                const ButtonSegment(value: 'document', label: Text('Full Doc')),
                if (widget.currentPage != null)
                  ButtonSegment(value: 'page', label: Text('Page ${widget.currentPage}')),
              ],
              selected: {_scope},
              onSelectionChanged: (s) {
                setState(() => _scope = s.first);
                _loadSummary();
              },
            ),
          ),

          // Content
          Expanded(
            child: _isLoading
                ? const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(color: AppColors.primary),
                        SizedBox(height: 16),
                        Text('Synthesizing comprehensive summary with AI...'),
                      ],
                    ),
                  )
                : _error != null
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.error_outline, color: AppColors.error, size: 36),
                            const SizedBox(height: 12),
                            Text(_error!),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: _loadSummary,
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? AppColors.surfaceContainerLow
                                      : AppColors.lightSurfaceVariant,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: isDark ? AppColors.whisperBorder : AppColors.lightDivider,
                                  ),
                                ),
                                child: SingleChildScrollView(
                                  child: SelectableText(
                                    _summaryContent,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 13.5,
                                      height: 1.55,
                                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton.icon(
                                    icon: const Icon(Icons.copy_rounded, size: 16),
                                    label: const Text('Copy'),
                                    onPressed: () {
                                      Clipboard.setData(ClipboardData(text: _summaryContent));
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Summary copied to clipboard'),
                                          behavior: SnackBarBehavior.floating,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    icon: const Icon(Icons.send_rounded, size: 16),
                                    label: const Text('Send to Canvas'),
                                    onPressed: () {
                                      ref.read(canvasProvider.notifier).addSummaryCard(
                                            documentId: widget.document.id,
                                            summary: _summaryContent,
                                            pageNumber: widget.currentPage ?? 1,
                                          );
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Summary card placed on Study Canvas'),
                                          behavior: SnackBarBehavior.floating,
                                        ),
                                      );
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
