import 'package:wealth_os/src/core/database/app_database.dart';
import 'package:wealth_os/src/core/database/dao/currencies_dao.dart';

/// Repository over the currencies table.
///
/// It wraps [CurrenciesDao] and delegates to it — nothing more. Every method here is
/// a one-line forward to a DAO method; there is no filtering, no ordering, no
/// caching, no mapping. That is deliberate for this step: the repository exists so
/// the layers above depend on *it* rather than on Drift, giving one seam to evolve
/// later, but at this point that seam is a straight passthrough.
///
/// It reaches the database **only through the DAO** — it never selects or touches a
/// Drift table itself. The DAO owns the SQL; the repository owns the dependency
/// direction.
///
/// **Read-only**, mirroring the DAO: the seed is the only writer for now, so there
/// are no create / update / delete methods to forward.
///
/// ## Where this grows
///
/// Under strict Clean Architecture a repository would eventually return *domain
/// entities* rather than Drift's generated `Currency` rows, mapping between the two
/// at this boundary — that is the point of having the seam. This task's rule is
/// "delegate only, no transformations", so the Drift types pass straight through for
/// now; the mapping is added the day a domain model exists, without any caller above
/// needing to change which class they depend on.
class CurrenciesRepository {
  CurrenciesRepository(this._dao);

  final CurrenciesDao _dao;

  /// Watches every currency, active and inactive alike.
  Stream<List<Currency>> watchAllCurrencies() => _dao.watchAllCurrencies();

  /// Watches only the active currencies.
  Stream<List<Currency>> watchActiveCurrencies() =>
      _dao.watchActiveCurrencies();

  /// The currency with [id], or null.
  Future<Currency?> getCurrencyById(String id) => _dao.getCurrencyById(id);

  /// The base currency, or null if none is marked.
  Future<Currency?> getBaseCurrency() => _dao.getBaseCurrency();
}
