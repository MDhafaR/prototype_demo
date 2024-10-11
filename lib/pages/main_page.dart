part of 'pages.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final TextEditingController _searchController = TextEditingController();
  final SearchableDropdownController<int> searchableDropdownController =
      SearchableDropdownController<int>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    context.read<NamaBalaiCubit>().fetchNamaBalaiFromApi();
    _initLoadNamaBalai();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    context.read<NamaBalaiCubit>().searchNamaBalai(_searchController.text);
  }

  _initLoadNamaBalai() {
    context.read<NamaBalaiCubit>().loadNamaBalai(refresh: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nama Balai"),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await _initLoadNamaBalai();
          },
          child: BlocBuilder<NamaBalaiCubit, NamaBalaiState>(
            builder: (context, state) {
              if (state is NamaBalaiInitial) {
                return _buildShimmerList();
              }
              if (state is NamaBalaiLoading) {
                return _buildShimmerList();
              }
              if (state is NamaBalaiError) {
                return _buildErrorView(state.message);
              }
              if (state is NamaBalaiLoaded) {
                return _buildNamaBalaiList(state);
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerList() {
    return ListView.separated(
      physics:
          const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
      itemCount: 6,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      itemBuilder: (context, index) => const ShimmerListNamaBalai(),
      separatorBuilder: (context, index) {
        return SizedBox(height: 10);
      },
    );
  }

  Widget _buildErrorView(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 155,
            height: 155,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/empty_data.png'))),
          ),
          SizedBox(height: 32),
          Text(message, style: TextStyle(fontSize: 16, color: Colors.grey))
        ],
      ),
    );
  }

  Widget _buildNamaBalaiList(NamaBalaiLoaded state) {
    return Column(
      children: [
        SizedBox(height: 16),
        Expanded(
          child: InputDecorator(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                labelText: 'Nama Balai',
              ),
              child: _buildSearchableDropdown()),
        ),
      ],
    );
  }

  Widget _buildSearchableDropdown() {
    return BlocBuilder<NamaBalaiCubit, NamaBalaiState>(
      builder: (context, state) {
        if (state is NamaBalaiLoaded) {
          return SearchableDropdown<int>.paginated(
            controller: searchableDropdownController,
            hintText: const Text('Pilih Nama Balai'),
            margin: const EdgeInsets.all(15),
            paginatedRequest: (int page, String? searchKey) async {
              if (page > 1 ) {
                await context.read<NamaBalaiCubit>().loadMoreNamaBalai();
              }

              // Ambil state terbaru setelah memuat lebih banyak data
              final currentState = context.read<NamaBalaiCubit>().state;
              if (currentState is NamaBalaiLoaded) {
                final filteredList = searchKey != null && searchKey.isNotEmpty
                    ? currentState.namaBalaiList
                        .where((balai) => balai.nama
                            .toLowerCase()
                            .contains(searchKey.toLowerCase()))
                        .toList()
                    : currentState.namaBalaiList;

                return filteredList
                    .map((e) => SearchableDropdownMenuItem(
                        value: e.id, label: e.nama, child: Text(e.nama)))
                    .toList();
              }
              return [];
            },
            requestItemCount:
                5, // Sesuaikan dengan jumlah item per halaman yang Anda inginkan
            onChanged: (int? value) {
              if (value != null) {
                final currentState = context.read<NamaBalaiCubit>().state;
                if (currentState is NamaBalaiLoaded) {
                  final selectedBalai = currentState.namaBalaiList
                      .firstWhere((balai) => balai.id == value);
                  print("Selected: ${selectedBalai.nama}");
                }
              }
            },
          );
        }
        // Tampilkan loading atau widget lain jika state bukan NamaBalaiLoaded
        return CircularProgressIndicator();
      },
    );
  }
}

class ShimmerListNamaBalai extends StatelessWidget {
  const ShimmerListNamaBalai({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Skelton(
              width: double.infinity,
              height: 24,
              radius: 8,
            ),
            SizedBox(height: 8),
            Skelton(
              width: 142,
              height: 16,
              radius: 8,
            ),
          ],
        ),
      ),
    );
  }
}

class CardNamaBalai extends StatelessWidget {
  final NamaBalai namaBalai;

  const CardNamaBalai({Key? key, required this.namaBalai}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(namaBalai.nama),
        // Add more details as needed
      ),
    );
  }
}
