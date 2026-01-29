{
  app = {
    quit = "super+q";
    forceQuit = "super+option+escape";
    showHelp = "super+shift+/";
  };

  system = {
    search = "super+space";
    nextApp = "super+tab";
    previousApp = "super+shift+tab";
    toggleDock = "super+option+d";
    screenshot = "super+shift+3";
    selectiveScreenshot = "super+shift+4";
    openScreenshotTool = "super+shift+5";
    lockScreen = "ctrl+super+q";
    logOut = "super+shift+q";
    logOutWithoutConfirmation = "super+option+shift+q";
  };

  inputManagement = {
    showCharacterViewer = "ctrl+super+space";
    toggleScreenReader = "super+f5";
    nextInputSource = "ctrl+space";
    previousInputSource = "ctrl+shift+space";
  };

  windowManagement = {
    hide = "super+h";
    hideOthers = "super+option+h";
    hideApp = "super+option+m";
    nextWindowOfApp = "super+`";
    previousWindowOfApp = "super+shift+`";
    showAllWindows = "ctrl+up";
    showAppWindows = "ctrl+down";
    showDesktop = "f11";

    tiling = {
      fill = "ctrl+shift+q";
      left = "ctrl+shift+1";
      right = "ctrl+shift+2";
      top = "ctrl+shift+w";
      bottom = "ctrl+shift+s";
    };
  };

  preferences = {
    open = "super+comma";
    reload = "super+shift+comma";
  };

  file = {
    newFile = "super+n";
    open = "super+o";
    save = "super+s";
    saveAs = "super+shift+s";
    saveAll = "super+option+s";
    reopenLastFile = "super+shift+t";
    print = "super+p";
    pageSetup = "super+shift+p";
  };

  fileManager = {
    newWindow = "super+n";
    newFolder = "super+shift+n";
    newSmartFolder = "super+option+n";
    rename = "return";
    open = "super+down";
    goUp = "super+up";
    goBack = "super+[";
    goForward = "super+]";
    viewAsIcons = "super+1";
    viewAsList = "super+2";
    viewAsColumns = "super+3";
    viewAsGallery = "super+4";
    duplicate = "super+d";
    eject = "super+e";
    find = "super+f";
    gotoFolder = "super+shift+g";
    copyPath = "super+option+c";
    openTerminalHere = "ctrl+shift+o";
    getInfo = "super+i";
    showHiddenFiles = "super+shift+.";
    showViewOptions = "super+j";
    connectToServer = "super+k";
    makeAlias = "super+ctrl+a";
    showOriginal = "super+r";
    toggleTabBar = "super+shift+t";
    moveClipboardHere = "super+option+v";
    quickLook = "space";
    quickLookSlideshow = "super+option+y";
    throwAway = "super+backspace";
    deleteImmediately = "super+option+backspace";
    emptyTrash = "super+shift+delete";
    emptyTrashSecurely = "super+option+shift+delete";
    openHome = "super+shift+h";
    openDesktop = "super+shift+d";
    openDocuments = "super+shift+o";
    openDownloads = "super+option+l";
    openComputer = "super+shift+c";
    openNetwork = "super+shift+k";
    openUtilities = "super+shift+u";
    openRecents = "super+shift+f";
    togglePreviewPane = "super+shift+p";
    togglePathBar = "super+option+p";
    toggleSidebar = "super+option+s";
    toggleStatusBar = "super+/";
  };

  edit = {
    undo = "super+z";
    redo = "super+shift+z";
    cut = "super+x";
    copy = "super+c";
    paste = "super+v";
    pasteSpecial = "super+shift+v";
    selectAll = "super+a";
    selectInverse = "super+option+a";
    toggleComment = "super+/";
    indent = "super+]";
    unindent = "super+[";
    joinLines = "super+shift+j";
    duplicateLine = "super+d";
    deleteWordBackward = "option+backspace";
    deleteWordForward = "option+delete";
    bold = "super+b";
    italic = "super+i";
    underline = "super+u";
    showFonts = "super+t";
    showDefinition = "ctrl+super+d";
    insertLineAfter = "ctrl+o";
    copyStyle = "super+option+c";
    pasteStyle = "super+option+v";
    pasteAndMatchStyle = "super+option+shift+v";
    showSpellingGrammar = "super+shift+:";
    findMisspelled = "super+;";
    alignLeft = "super+shift+[";
    alignRight = "super+shift+]";
    alignCenter = "super+shift+\\";
  };

  find = {
    find = "super+f";
    findNext = "super+g";
    findPrevious = "super+shift+g";
    findInFiles = "super+shift+f";
    replace = "super+f";
    useSelectionForFind = "super+e";
    useSelectionForReplace = "super+shift+e";
    gotoSearchField = "super+option+f";

    incrementalFind = "super+i";
    incrementalFindReverse = "super+shift+i";
    replaceNext = "super+option+e";
    findUnder = "ctrl+d";
    findUnderPrev = "shift+option+super+g";
    findAllUnder = "ctrl+super+g";
    nextResult = "f8";
    previousResult = "shift+f8";

    toggleCaseSensitive = "super+option+c";
    toggleRegex = "super+option+r";
    toggleWholeWord = "super+option+w";
    togglePreserveCase = "super+option+a";

    gotoFile = "escape+a";
    commandPalette = [
      "escape+s"
      "super+shift+p"
    ];
    gotoSymbol = "super+r";
    gotoSymbolInProject = "super+shift+r";
    gotoLine = "super+l";
    gotoDefinition = "f12";
    gotoReference = "shift+f12";
  };

  windowNavigation = {
    newTab = "super+t";
    newWindow = "super+shift+n";

    closeTab = "super+w";
    closeWindow = "super+shift+w";
    closeAll = "super+option+w";

    nextTab = "super+shift+]";
    previousTab = "super+shift+[";
    findTab = "super+shift+a";

    back = "super+[";
    forward = "super+]";
    home = "super+shift+h";
    openMenu = "super+shift+m";

    focusLocation = "super+l";
    focusNextPane = "super+option+down";
    focusPreviousPane = "super+option+up";

    reload = "super+r";
    cancel = "super+.";

    goToTab1 = "super+1";
    goToTab2 = "super+2";
    goToTab3 = "super+3";
    goToTab4 = "super+4";
    goToTab5 = "super+5";
    goToTab6 = "super+6";
    goToTab7 = "super+7";
    goToTab8 = "super+8";
    goToTab9 = "super+9";
  };

  textNavigation = {
    jumpBack = "ctrl+minus";
    jumpForward = "ctrl+shift+minus";
    jumpToSelection = "super+j";
    focusPrevious = "super+option+up";
    focusNext = "super+option+down";
    moveWordBackward = "option+left";
    moveWordForward = "option+right";
    selectWordBackward = "option+shift+left";
    selectWordForward = "option+shift+right";

    moveToLineStart = "super+left";
    moveToLineEnd = "super+right";
    moveToParagraphStart = "ctrl+a";
    moveToParagraphEnd = "ctrl+e";
    moveToDocumentStart = "super+up";
    moveToDocumentEnd = "super+down";
    moveLeftBySubword = "ctrl+left";
    moveRightBySubword = "ctrl+right";
    selectLeftBySubword = "ctrl+shift+left";
    selectRightBySubword = "ctrl+shift+right";
    selectToLineStart = "super+shift+left";
    selectToLineEnd = "super+shift+right";
    selectToDocumentStart = "super+shift+up";
    selectToDocumentEnd = "super+shift+down";
    centerSelection = "ctrl+l";
  };

  view = {
    toggleToolbar = "super+option+t";
    toggleInspector = "super+option+i";
    toggleFullScreen = "super+ctrl+f";
    zoomIn = "super+equal";
    zoomOut = "super+minus";
    resetZoom = "super+0";
    clearScreen = "super+k";
  };

  bookmarks = {
    add = "super+d";
    addAllTabs = "super+shift+d";
    manager = "super+option+b";
    toggleBar = "super+shift+b";
  };

  browser = {
    hardReload = "super+shift+r";
    history = "super+y";
    clearData = "super+shift+backspace";
    viewSource = "super+option+u";
    developerTools = "super+shift+i";
    inspectElement = "super+shift+c";
    inspectElementAlt = "super+option+c";
    devConsole = "super+option+j";
  };

  textEditor = {
    softUndo = "super+u";
    softRedo = "super+shift+u";
    pasteFromHistory = "super+option+v";
    splitSelectionIntoLines = "super+shift+l";
    expandSelectionToLine = "super+shift+l";
    expandSelectionToScope = "super+shift+space";
    expandSelectionToBrackets = "ctrl+shift+m";
    expandSelectionToTag = "super+shift+a";
    moveToBrackets = "ctrl+m";
    closeTag = "super+option+.";
    swapLineUp = "super+up";
    swapLineDown = "super+down";
    deleteWordLeft = "ctrl+backspace";
    deleteWordRight = "ctrl+delete";
    sortLines = "f5";
    sortLinesCaseSensitive = "ctrl+f5";
    wrapLines = "super+option+q";
    upperCase = "super+k,super+u";
    lowerCase = "super+k,super+l";
    deleteToHardBOL = "super+backspace";
    deleteToHardEOL = "super+delete";
    deleteLine = "ctrl+shift+k";

    gotoDefinitionAlt = "super+option+down";
    gotoReferenceAlt = "super+option+shift+down";
    columnCursorUp = "option+up";
    columnCursorDown = "option+down";
    scrollLineUp = "ctrl+option+up";
    scrollLineDown = "ctrl+option+down";

    toggleSideBar = "super+k,super+b";
    toggleDistractionFree = "super+ctrl+shift+f";
    showPanelConsole = "ctrl+`";
    hidePanel = "escape";
    hideOverlay = "escape";
    hideAutoComplete = "escape";
    showScopeName = "super+option+p";
    showAtCenter = "ctrl+l";
    fold = "super+option+[";
    unfold = "super+option+]";
    unfoldAll = "super+k,super+j";
    foldByLevel1 = "super+k,super+1";
    foldByLevel2 = "super+k,super+2";
    foldByLevel3 = "super+k,super+3";
    foldByLevel4 = "super+k,super+4";
    foldByLevel5 = "super+k,super+5";
    foldByLevel6 = "super+k,super+6";
    foldByLevel7 = "super+k,super+7";
    foldByLevel8 = "super+k,super+8";
    foldByLevel9 = "super+k,super+9";
    newPane = "super+k,super+up";
    closePane = "super+k,super+down";
    focusNeighboringGroup = "super+k,super+right";
    focusGroup0 = "ctrl+0";
    focusGroup1 = "ctrl+1";
    focusGroup2 = "ctrl+2";
    focusGroup3 = "ctrl+3";
    focusGroup4 = "ctrl+4";
    focusGroup5 = "ctrl+5";
    focusGroup6 = "ctrl+6";
    focusGroup7 = "ctrl+7";
    focusGroup8 = "ctrl+8";
    focusGroup9 = "ctrl+9";
    moveToGroup1 = "ctrl+shift+1";
    moveToGroup2 = "ctrl+shift+2";
    moveToGroup3 = "ctrl+shift+3";
    moveToGroup4 = "ctrl+shift+4";
    moveToGroup5 = "ctrl+shift+5";
    moveToGroup6 = "ctrl+shift+6";
    moveToGroup7 = "ctrl+shift+7";
    moveToGroup8 = "ctrl+shift+8";
    moveToGroup9 = "ctrl+shift+9";
  };

  terminal = {
    scrollToSelection = "super+j";
    adjustSelectionLeft = "shift+left";
    adjustSelectionRight = "shift+right";
    adjustSelectionUp = "shift+up";
    adjustSelectionDown = "shift+down";
    adjustSelectionPageUp = "shift+page_up";
    adjustSelectionPageDown = "shift+page_down";
    adjustSelectionHome = "shift+home";
    adjustSelectionEnd = "shift+end";
    jumpToPromptPrevious = "super+up";
    jumpToPromptNext = "super+down";
    shellJumpToLineStart = "super+left"; # Emits ctrl+a
    shellJumpToLineEnd = "super+right"; # Emits ctrl+e
    shellDeleteLine = "super+backspace"; # Emits ctrl+u
    shellWordBack = "option+left"; # Emits esc, then b
    shellWordForward = "option+right"; # Emits esc, then f
    writeScreenToFileCopy = "super+shift+ctrl+j";
    writeScreenToFilePaste = "super+shift+j";

    # Emacs-style cursor navigation
    moveForward = "ctrl+f";
    moveBackward = "ctrl+b";
    moveLineUp = "ctrl+p";
    moveLineDown = "ctrl+n";
    transpose = "ctrl+t";
    yank = "ctrl+y";
    deleteCharacterBackward = "ctrl+h";
    deleteCharacterForward = "ctrl+d";
    deleteToEndOfParagraph = "ctrl+k";
    scrollToTop = "super+home";
    scrollToBottom = "super+end";
    scrollPageUp = "super+page_up";
    scrollPageDown = "super+page_down";
    scrollLinesUp = "ctrl+option+up";
    scrollLinesDown = "ctrl+option+down";
    jumpToPromptUp = "super+up";
    jumpToPromptDown = "super+down";

    inspectorToggle = "super+option+i";
    newSplitRight = "super+d";
    newSplitDown = "super+shift+d";
    toggleSplitZoom = "super+shift+enter";
    gotoPreviousSplit = "super+[";
    gotoNextSplit = "super+]";
    gotoSplitUp = "super+option+up";
    gotoSplitDown = "super+option+down";
    gotoSplitLeft = "super+option+left";
    gotoSplitRight = "super+option+right";
    equalizeSplits = "super+ctrl+equal";
    resizeSplitUp = "super+ctrl+up";
    resizeSplitDown = "super+ctrl+down";
    resizeSplitLeft = "super+ctrl+left";
    resizeSplitRight = "super+ctrl+right";
  };
}
