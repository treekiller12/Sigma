class _MainScreenState extends State<MainScreen> {
  int currentPageIndex = 0;

  FocusNode homeFocusNode = FocusNode();
  FocusNode watchedFocusNode = FocusNode();
  FocusNode offlineFocusNode = FocusNode();
  FocusNode settingsFocusNode = FocusNode();

  @override
  void dispose() {
    homeFocusNode.dispose();
    watchedFocusNode.dispose();
    offlineFocusNode.dispose();
    settingsFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Row(
        children: [
          FocusScope(
            child: MouseRegion(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 200,
                color: Colors.grey[850],
                child: ListView(
                  children: [
                    _buildMenuItem(Icons.home, "Strona Główna", 0, homeFocusNode),
                    _buildMenuItem(Icons.watch_later, "Oglądane", 1, watchedFocusNode),
                    _buildMenuItem(Icons.download, "Pobrane", 2, offlineFocusNode),
                    _buildMenuItem(Icons.settings, "Ustawienia", 3, settingsFocusNode),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: IndexedStack(
              index: currentPageIndex,
              children: const [
                HomePage(),
                WatchedPage(),
                OfflinePage(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String label, int index, FocusNode focusNode) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Focus(
        focusNode: focusNode,
        onFocusChange: (hasFocus) {
          if (hasFocus) {
            setState(() {
              currentPageIndex = index;
            });
          }
        },
        child: ListTile(
          tileColor: focusNode.hasFocus ? Colors.green : Colors.transparent,
          leading: Icon(icon, color: focusNode.hasFocus ? Colors.white : Colors.grey),
          title: Text(
            label,
            style: TextStyle(
              color: focusNode.hasFocus ? Colors.white : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
