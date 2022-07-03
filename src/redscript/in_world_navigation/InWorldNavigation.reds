public native class InWorldNavigation extends IScriptable {
  public static native func GetInstance() -> ref<InWorldNavigation>;

  public let mmcc: ref<MinimapContainerController>;
  public let player: ref<GameObject>;
  let spacing: Float;
  let maxPoints: Int32;
  let distanceToFade: Float;

  let navPathQuestFX: array<ref<FxInstance>>;
  let navPathPOIFX: array<ref<FxInstance>>;

  let navPathYellowResource: FxResource;
  let navPathBlueResource: FxResource;
  let navPathWhiteResource: FxResource;
  let navPathTealResource: FxResource;
  let navPathCyanResource: FxResource;

  let questVariant: gamedataMappinVariant;
  let poiVariant: gamedataMappinVariant;


  public func Setup(player: ref<GameObject>) -> Void {
    this.player = player;
    this.spacing = 3.0; // meters
    this.maxPoints = 100;
    this.distanceToFade = 25.0;

    this.navPathYellowResource = Cast<FxResource>(r"user\\mathbou\\effects\\world_navigation_yellow.effect");
    this.navPathBlueResource = Cast<FxResource>(r"user\\mathbou\\effects\\world_navigation_blue.effect");
    this.navPathWhiteResource = Cast<FxResource>(r"user\\mathbou\\effects\\world_navigation_white.effect");
    this.navPathTealResource = Cast<FxResource>(r"user\\mathbou\\effects\\world_navigation_teal.effect");
    this.navPathCyanResource = Cast<FxResource>(r"user\\mathbou\\effects\\world_navigation_cyan.effect");
  }

  public func GetResourceForVariant(variant: gamedataMappinVariant) -> FxResource {
      switch (variant) {
        case gamedataMappinVariant.Zzz02_MotorcycleForPurchaseVariant:
        case gamedataMappinVariant.Zzz01_CarForPurchaseVariant:
        case gamedataMappinVariant.Zzz05_ApartmentToPurchaseVariant:
        case gamedataMappinVariant.QuestGiverVariant:
        case gamedataMappinVariant.FixerVariant:
        case gamedataMappinVariant.RetrievingVariant:
        case gamedataMappinVariant.SabotageVariant:
        case gamedataMappinVariant.ClientInDistressVariant:
        case gamedataMappinVariant.ThieveryVariant:
        case gamedataMappinVariant.HuntForPsychoVariant:
        case gamedataMappinVariant.Zzz06_NCPDGigVariant:
        case gamedataMappinVariant.BountyHuntVariant:
         return this.navPathTealResource;
          break;
        case gamedataMappinVariant.DefaultQuestVariant:
        case gamedataMappinVariant.ExclamationMarkVariant:
          return this.navPathYellowResource;
          break;
        case gamedataMappinVariant.TarotVariant:
        case gamedataMappinVariant.FastTravelVariant:
          return this.navPathBlueResource;
          break;
        case gamedataMappinVariant.GangWatchVariant:
        case gamedataMappinVariant.HiddenStashVariant:
        case gamedataMappinVariant.OutpostVariant:
          return this.navPathCyanResource;
          break;
        case gamedataMappinVariant.ServicePointDropPointVariant:
        case gamedataMappinVariant.CustomPositionVariant:
          return this.navPathWhiteResource;
          break;
      }
      return this.navPathWhiteResource;
  }

  public func Update(canUpdate: Int32) {
    if IsDefined(this.mmcc) {
      let questMappin = this.mmcc.GetQuestMappin();
      if IsDefined(questMappin) {
        let questVariant = questMappin.GetVariant();
        if !Equals(questVariant, this.questVariant) {
          this.questVariant = questVariant;
        }
        this.UpdateNavPath(this.navPathQuestFX, this.mmcc.questPoints, this.GetResourceForVariant(this.questVariant));
      } else {
        this.StopQuest();
      }
      let poiMappin = this.mmcc.GetPOIMappin();
      if IsDefined(poiMappin) {
        let poiVariant = poiMappin.GetVariant();
        if !Equals(poiVariant, this.poiVariant) {
          this.poiVariant = poiVariant;
        }
        this.UpdateNavPath(this.navPathPOIFX, this.mmcc.poiPoints, this.GetResourceForVariant(this.poiVariant));
      } else {
        this.StopPOI();
      }
    }
  }

  private func KillFx(fx: ref<FxInstance>) {
      fx.SetBlackboardValue(n"alpha", 0.0);
      fx.BreakLoop();
      fx.Kill();
  }

  private func StopQuest() {
    for fx in this.navPathQuestFX {
      this.KillFx(fx);
    }
  }

  private func StopPOI() {
    for fx in this.navPathPOIFX {
      this.KillFx(fx);
    }
  }

  public func Stop() {
    this.StopQuest();
    this.StopPOI();
  }

  private func BezierPoint(P1: Vector4, P2: Vector4, P3: Vector4, t: Float) -> Vector4 {
    // https://javascript.info/bezier-curve
    let a: Vector4 = PowF((1.0 - t), 2.0) * P1;
    let b: Vector4 = 2.0 * (1.0 - t) * t * P2;
    let c: Vector4 = PowF(t, 2.0) * P3;

    let P: Vector4 = a + b + c;
    return P;
  }

  private func BezierLengthApproximation(P1: Vector4, P2: Vector4, P3: Vector4) -> Float {
    let S1: Vector4 = this.BezierPoint(P1, P2, P3, 0.25);
    let S2: Vector4 = this.BezierPoint(P1, P2, P3, 0.5);
    let S3: Vector4 = this.BezierPoint(P1, P2, P3, 0.75);

    let Length: Float = Vector4.Distance(P1, S1);
    Length += Vector4.Distance(S1, S2);
    Length += Vector4.Distance(S2, S3);
    Length += Vector4.Distance(S3, P3);

    return Length;
  }

  private func UpdateNavPath(out fxs: array<ref<FxInstance>>, points: array<Vector4>, resource: FxResource) -> Void {
    let lastPoint: Vector4 = this.player.GetWorldPosition();

    let dots: array<Vector4>;
    ArrayPush(dots, lastPoint);

    for point in points {
      if ArraySize(dots) >= this.maxPoints / 3 { break; }

      let tweenPointDistance: Float = Vector4.Distance(point, lastPoint);
      let tweenPointCount: Float = Cast(FloorF(tweenPointDistance / (this.spacing * 3.0 )));

      if tweenPointCount >= 1.0 {
        let i: Float = 0.0;

        while i < tweenPointCount {
          let ratio: Float = i / tweenPointCount;

          let position = Vector4.Interpolate(lastPoint, point, ratio);
          position.Z = MaxF(point.Z, lastPoint.Z);
          ArrayPush(dots, position);

          i += 1.0;
        }

        lastPoint = point;
      }
    }

    let dot_count: Int32 = ArraySize(dots);
    // Ensure odd dot count
    if dot_count % 2 == 0 {
        ArrayPop(dots);
        dot_count -= 1;
    }

    let i: Int32 = 0;
    let pointDrawnCount: Int32 = 0;
    let lastPoint: Vector4 = dots[0];

    while i < dot_count {
        let p1: Vector4 = dots[i];
        let p2: Vector4 = dots[i+1];
        let p3: Vector4 = dots[i+2];

        let curveLength: Float = this.BezierLengthApproximation(p1, p2, p3);
        let tweenPointCount: Float = Cast(FloorF(curveLength / this.spacing));

        let j: Float = 0.0;
        while j < tweenPointCount {
            if pointDrawnCount >= this.maxPoints {break;}

            let ratio: Float = j/tweenPointCount;
            let bezierPoint = this.BezierPoint(p1, p2, p3, ratio);

            let orientation = Quaternion.BuildFromDirectionVector(bezierPoint - lastPoint);

            bezierPoint.Z = MaxF(p1.Z, MaxF(p2.Z, p3.Z)); // the spawnOnGround doesnt work well if z is below the ground

            this.UpdateFxInstance(fxs, pointDrawnCount, bezierPoint, orientation, resource);

            j += 1.0;
            pointDrawnCount += 1;
            lastPoint = bezierPoint;
      }

      if pointDrawnCount >= this.maxPoints {break;}
      i += 2; // 2 segments are done by loop

    }

  }

  private func UpdateFxInstance(out fxs: array<ref<FxInstance>>, i: Int32, p: Vector4, q: Quaternion, resource: FxResource) {
    let wt: WorldTransform;
    WorldTransform.SetPosition(wt, p);
    WorldTransform.SetOrientation(wt, q);

    if ArraySize(fxs) <= i {
      ArrayPush(fxs, GameInstance.GetFxSystem(this.player.GetGame()).SpawnEffectOnGround(resource, wt));
    } else {
      this.KillFx(fxs[i]);
      fxs[i] = GameInstance.GetFxSystem(this.player.GetGame()).SpawnEffectOnGround(resource, wt);
    }
    fxs[i].SetBlackboardValue(n"alpha", MinF(Vector4.Distance(this.player.GetWorldPosition(), p) / this.distanceToFade, 1.0));
  }
}