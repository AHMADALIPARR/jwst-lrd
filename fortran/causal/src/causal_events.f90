! Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
! Dual-licensed: AGPL-3.0-only plus SnapKitty Opaque License.
! SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
!
! causal_events: the four DISTINCT observation event kinds and the event record.
!   EV_EMISSION              astronomical emission at the source
!   EV_DETECTION             photon detection on the spacecraft (e.g. JWST NIRSpec)
!   EV_GROUND_RECEIPT        telemetry receipt at a ground station
!   EV_ARCHIVE_PUBLICATION   publication of the product in an archive (e.g. MAST)
!
! Kind-ordering policy for a DIRECT edge a -> b (see kind_edge_allowed):
!   allowed:  Emission -> Detection, Detection -> GroundReceipt,
!             GroundReceipt -> ArchivePublication   (the observation pipeline)
!   rejected: everything else, namely
!     * backward kinds (X -> Emission, ArchivePublication -> X, GroundReceipt ->
!       Detection, ...): the pipeline never produces an earlier stage;
!     * skipped stages (Emission -> GroundReceipt, Emission -> ArchivePublication,
!       Detection -> ArchivePublication): the intermediate event must be explicit;
!       the indirect relation is then DERIVED by reachability (causalBefore);
!     * same kind (Emission -> Emission, ...): intra-stage causation (re-emission,
!       reprocessing, re-publication) is not modelled in v1 (documented gap).
module causal_events
  use causal_coords
  implicit none
  private

  integer, parameter, public :: EV_INVALID = 0, EV_EMISSION = 1, EV_DETECTION = 2, &
                                EV_GROUND_RECEIPT = 3, EV_ARCHIVE_PUBLICATION = 4

  type, public :: event
    integer :: id = 0
    integer :: kind = EV_INVALID
    character(len=64) :: label = ''
    type(stcoord) :: c
  end type event

  public :: kind_name, kind_from_name, kind_edge_allowed, make_event

contains

  pure function kind_name(k) result(s)
    integer, intent(in) :: k
    character(len=:), allocatable :: s
    select case (k)
    case (EV_EMISSION);            s = 'emission'
    case (EV_DETECTION);           s = 'detection'
    case (EV_GROUND_RECEIPT);      s = 'ground_receipt'
    case (EV_ARCHIVE_PUBLICATION); s = 'archive_publication'
    case default;                  s = 'invalid'
    end select
  end function kind_name

  pure integer function kind_from_name(s)
    character(len=*), intent(in) :: s
    select case (s)
    case ('emission');            kind_from_name = EV_EMISSION
    case ('detection');           kind_from_name = EV_DETECTION
    case ('ground_receipt');      kind_from_name = EV_GROUND_RECEIPT
    case ('archive_publication'); kind_from_name = EV_ARCHIVE_PUBLICATION
    case default;                 kind_from_name = EV_INVALID
    end select
  end function kind_from_name

  pure logical function kind_edge_allowed(ka, kb)
    integer, intent(in) :: ka, kb
    kind_edge_allowed = (ka == EV_EMISSION .and. kb == EV_DETECTION) .or. &
                        (ka == EV_DETECTION .and. kb == EV_GROUND_RECEIPT) .or. &
                        (ka == EV_GROUND_RECEIPT .and. kb == EV_ARCHIVE_PUBLICATION)
  end function kind_edge_allowed

  pure function make_event(id, kind, label, c) result(e)
    integer, intent(in) :: id, kind
    character(len=*), intent(in) :: label
    type(stcoord), intent(in) :: c
    type(event) :: e
    e%id = id
    e%kind = kind
    e%label = label
    e%c = c
  end function make_event

end module causal_events
