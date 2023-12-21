*&---------------------------------------------------------------------*
*& Report ZTEST_ABAPGIT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZTEST_ABAPGIT.


TABLES : zzstrat_ex_02.


DATA: it_ZZstrat_ex_02 TYPE TABLE OF zzstrat_ex_02,
      lwa_rows    TYPE int4,
      lwa_ZZstrat_ex_02  TYPE zzstrat_ex_02,
      lt_rows     TYPE salv_t_row.

* Local deleclarations.
DATA: lr_selections TYPE REF TO cl_salv_selections.
DATA alv TYPE REF TO cl_salv_table.
DATA: lr_columns    TYPE REF TO cl_salv_columns_table.

*----------------------------------------------------------------------
* Event handler for The main ALV: On Double click => Go to TRANSACTION
*----------------------------------------------------------------------
CLASS lcl_event_handler DEFINITION.
  PUBLIC SECTION.
    METHODS:
      on_double_click FOR EVENT double_click OF cl_salv_events_table
        IMPORTING row column,
      on_link_click FOR EVENT link_click OF cl_salv_events_table
        IMPORTING row column,
      on_user_command FOR EVENT added_function OF cl_salv_events
        IMPORTING e_salv_function.
ENDCLASS.                    "lcl_event_handler DEFINITION


CLASS lcl_event_handler IMPLEMENTATION.
  METHOD on_link_click.
  ENDMETHOD.                    "on_link_click
  METHOD on_double_click.
    MESSAGE i001(00) WITH 'Double click: column- ' column ' / line- ' row.
  ENDMETHOD.                    "on_double_click
  METHOD on_user_command.
*    case e_salv_function.
*    endcase.
  ENDMETHOD.                    "on_user_command
ENDCLASS.                    "lcl_event_handler IMPLEMENTATION

START-OF-SELECTION.
  PERFORM get_data.

  PERFORM initialize_alv.

  PERFORM display_alv.


FORM get_data.
SELECT *
  FROM ZZstrat_ex_02
  INTO TABLE it_ZZstrat_ex_02.
ENDFORM.



FORM initialize_alv.
* Call the factory method
  DATA message TYPE REF TO cx_salv_msg.

  TRY.
      cl_salv_table=>factory(
      IMPORTING
        r_salv_table = alv
      CHANGING
        t_table      = it_ZZstrat_ex_02 ).
    CATCH cx_salv_msg INTO message.
      " error handling
  ENDTRY.


* Column selection
  lr_selections = alv->get_selections( ).
  lr_selections->set_selection_mode( if_salv_c_selection_mode=>row_column ).

  lr_columns = alv->get_columns( ).
  lr_columns->set_optimize( abap_true ).



    TRY.
      alv->set_screen_status(
        EXPORTING
          report        = sy-repid
          pfstatus      = 'CUSTOM_PF_EX01'
          set_functions = alv->c_functions_all ).
    CATCH cx_salv_msg .
  ENDTRY.

ENDFORM.                    " INITIALIZE_ALV



*&---------------------------------------------------------------------*
FORM display_alv.
*&---------------------------------------------------------------------*
  alv->display( ).
ENDFORM.
