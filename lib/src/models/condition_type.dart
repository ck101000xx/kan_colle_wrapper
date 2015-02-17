part of kan_colle_wrapper.models;

enum ConditionType {
	/// <summary>
	/// キラキラ状態 (コンディション値 50 ～ 100)。
	/// </summary>
	brilliant,
	// 神宝「ブリリアントドラゴンバレッタ」

	/// <summary>
	/// 通常状態 (コンディション値 40 ～ 49)。
	/// </summary>
	normal,

	/// <summary>
	/// 疲労状態 (間宮点灯, コンディション値 30 ～ 39)。
	/// </summary>
	tired,

	/// <summary>
	/// 疲労状態 (橙アイコン, コンディション値 20 ～ 29)。
	/// </summary>
	orangeTired,

	/// <summary>
	/// 疲労状態 (赤アイコン, コンディション値 0 ～ 20)。
	/// </summary>
	redTired,
}

class ConditionTypeHelper {
	/// <summary>
	/// コンディション値を示す整数値から、<see cref="ConditionType"/> 値へ変換します。
	/// </summary>
	static ConditionType toConditionType(int condition) {
		if (condition >= 50) return ConditionType.brilliant;
		if (condition >= 40) return ConditionType.normal;
		if (condition >= 30) return ConditionType.tired;
		if (condition >= 20) return ConditionType.orangeTired;
		return ConditionType.redTired;
	}
}

