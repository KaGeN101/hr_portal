defmodule HrPortalWeb.SlipControllerTest do
  use HrPortalWeb.ConnCase

  alias PayrollServices.Salaries

  @create_attrs %{employee_id: 12, gross_income: 42, income_tax: 42, pay_period: 42}
  @update_attrs %{employee_id: 13, gross_income: 43, income_tax: 43, pay_period: 43}
  @invalid_attrs %{employee_id: nil, gross_income: nil, income_tax: nil, pay_period: nil}

  def fixture(:slip) do
    {:ok, slip} = Salaries.create_slip(@create_attrs)
    slip
  end

  describe "index" do
    test "lists all slips", %{conn: conn} do
      conn = get(conn, Routes.slip_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Slips"
    end
  end

  describe "new slip" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.slip_path(conn, :new))
      assert html_response(conn, 200) =~ "New Slip"
    end
  end

  describe "create slip" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.slip_path(conn, :create), slip: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.employee_path(conn, :show, id)

      conn = get(conn, Routes.slip_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Slip"
    end

    #test "renders errors when data is invalid", %{conn: conn} do
    #  conn = post(conn, Routes.slip_path(conn, :create), slip: @invalid_attrs)
    #  assert html_response(conn, 200) =~ "New Slip"
    #end
  end

  describe "edit slip" do
    setup [:create_slip]

    test "renders form for editing chosen slip", %{conn: conn, slip: slip} do
      conn = get(conn, Routes.slip_path(conn, :edit, slip))
      assert html_response(conn, 200) =~ "Edit Slip"
    end
  end

  describe "update slip" do
    setup [:create_slip]

    test "redirects when data is valid", %{conn: conn, slip: slip} do
      conn = put(conn, Routes.slip_path(conn, :update, slip), slip: @update_attrs)
      assert redirected_to(conn) == Routes.slip_path(conn, :show, slip)

      conn = get(conn, Routes.slip_path(conn, :show, slip))
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, slip: slip} do
      conn = put(conn, Routes.slip_path(conn, :update, slip), slip: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Slip"
    end
  end

  describe "delete slip" do
    setup [:create_slip]

    test "deletes chosen slip", %{conn: conn, slip: slip} do
      conn = delete(conn, Routes.slip_path(conn, :delete, slip))
      assert redirected_to(conn) == Routes.slip_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.slip_path(conn, :show, slip))
      end
    end
  end

  defp create_slip(_) do
    slip = fixture(:slip)
    {:ok, slip: slip}
  end
end
