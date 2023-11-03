

import UIKit


public final class EmojiViewController: UIViewController {

    // MARK: - Public Properties

    public weak var delegate: MCEmojiPickerDelegate?
    /// The default value of this property is `nil`.
    public var customHeight: CGFloat? = nil

    /// Inset from the sourceView border.
    ///
    /// The default value of this property is `0`.
    public var horizontalInset: CGFloat = 0


    /// Color for the selected emoji category.
    ///
    /// The default value of this property is `.systemBlue`.
    public var selectedEmojiCategoryTintColor: UIColor? {
        didSet {
            guard let selectedEmojiCategoryTintColor = selectedEmojiCategoryTintColor else { return }
            emojiPickerView.selectedEmojiCategoryTintColor = selectedEmojiCategoryTintColor
        }
    }

    /// Feedback generator style. To turn off, set `nil` to this parameter.
    ///
    /// The default value of this property is `.light`.
    public var feedBackGeneratorStyle: UIImpactFeedbackGenerator.FeedbackStyle? = .light {
        didSet {
            guard let feedBackGeneratorStyle = feedBackGeneratorStyle else {
                generator = nil
                return
            }
            generator = UIImpactFeedbackGenerator(style: feedBackGeneratorStyle)
        }
    }

    // MARK: - Private Properties

    private var generator: UIImpactFeedbackGenerator? = UIImpactFeedbackGenerator(style: .light)
    private var viewModel: MCEmojiPickerViewModelProtocol = MCEmojiPickerViewModel()
    private lazy var emojiPickerView: MCEmojiPickerView = {
        let categories = viewModel.emojiCategories.map { $0.type }
        return MCEmojiPickerView(categoryTypes: categories, delegate: self)
    }()

    // MARK: - Initializers

    public init() {
        super.init(nibName: nil, bundle: nil)
        bindViewModel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle

    public override func loadView() {
        view = emojiPickerView
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupPreferredContentSize()
    }

    // MARK: - Private Methods

    private func bindViewModel() {
        viewModel.selectedEmoji.bind { [unowned self] emoji in
            guard let emoji = emoji else { return }
            delegate?.didGetEmoji(emoji: emoji.string)
            feedbackImpactOccurred()
        }
        viewModel.selectedEmojiCategoryIndex.bind { [unowned self] categoryIndex in
            self.emojiPickerView.updateSelectedCategoryIcon(with: categoryIndex)
        }
    }


    private func setupPreferredContentSize() {
        preferredContentSize = {
            switch UIDevice.current.userInterfaceIdiom {
            case .phone:
                let sideInset: CGFloat = 19
                let screenWidth: CGFloat = UIScreen.main.nativeBounds.width / UIScreen.main.nativeScale
                let popoverWidth: CGFloat = screenWidth - (sideInset * 2)
                // The number 0.16 was taken based on the proportion of height to the width of the EmojiPicker on MacOS.
                let heightProportionToWidth: CGFloat = 1.16
                return CGSize(
                    width: popoverWidth,
                    height: customHeight ?? popoverWidth * heightProportionToWidth
                )
            default:
                return CGSize(width: 340, height: 380)
            }
        }()
    }
}

// MARK: - EmojiPickerViewDelegate

extension EmojiViewController: MCEmojiPickerViewDelegate {
    func didChoiceEmojiCategory(at index: Int) {
        updateCurrentSelectedEmojiCategoryIndex(with: index)
    }

    func numberOfSections() -> Int {
        viewModel.numberOfSections()
    }

    func numberOfItems(in section: Int) -> Int {
        viewModel.numberOfItems(in: section)
    }

    func emoji(at indexPath: IndexPath) -> MCEmoji {
        viewModel.emoji(at: indexPath)
    }

    func sectionHeaderName(for section: Int) -> String {
        viewModel.sectionHeaderName(for: section)
    }

    func getCurrentSelectedEmojiCategoryIndex() -> Int {
        viewModel.selectedEmojiCategoryIndex.value
    }

    func updateCurrentSelectedEmojiCategoryIndex(with index: Int) {
        viewModel.selectedEmojiCategoryIndex.value = index
    }

    func getEmojiPickerFrame() -> CGRect {
        presentationController?.presentedView?.frame ?? view.frame
    }

    func updateEmojiSkinTone(_ skinToneRawValue: Int, in indexPath: IndexPath) {
        viewModel.selectedEmoji.value = viewModel.updateEmojiSkinTone(
            skinToneRawValue,
            in: indexPath
        )
    }

    func feedbackImpactOccurred() {
        generator?.impactOccurred()
    }

    func didChoiceEmoji(_ emoji: MCEmoji?) {
        viewModel.selectedEmoji.value = emoji
    }
}


