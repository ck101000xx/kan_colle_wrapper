part of kan_colle_wrapper.models;

class ModernizableStatus {

	int max;
	
	int default_;
	
	int upgraded;
	
  int get current => default_ + upgraded;

  int get shortfall => max - current;

	bool get isMax => max <= current;

  ModernizableStatus(List<int> status, int this.upgraded) {
		if (status.length == 2) {
			default_ = status[0];
			max = status[1];
		}
	}

	@override String toString() {
		return "Status = ${default_}->${max}, Current = ${current}${isMax ? "(max)" : ""}";
	}

	static final ModernizableStatus dummy = new ModernizableStatus([-1, -1], 0);
}

