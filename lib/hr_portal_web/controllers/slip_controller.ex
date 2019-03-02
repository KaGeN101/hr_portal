defmodule HrPortalWeb.SlipController do
  use HrPortalWeb, :controller

  alias PayrollServices.Salaries

  def index(conn, _params) do
    slips = Salaries.list_slips()
    render(conn, "index.html", slips: slips)
  end

  def new(conn, _params) do
    changeset = Salaries.change_slip(%HumanResources.Slip{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"slip" => slip_params}) do
    case PayrollServices.SalariesServices.create_next_slip(slip_params["employee_id"]) do
      {:ok, slip} ->
        conn
        |> put_flash(:info, "Slip created successfully.")
        |> redirect(to: Routes.employee_path(conn, :show, slip.employee))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    slip = Salaries.get_slip!(id)
    render(conn, "show.html", slip: slip)
  end

  def edit(conn, %{"id" => id}) do
    slip = Salaries.get_slip!(id)
    changeset = Salaries.change_slip(slip)
    render(conn, "edit.html", slip: slip, changeset: changeset)
  end

  def update(conn, %{"id" => id, "slip" => slip_params}) do
    slip = Salaries.get_slip!(id)

    case Salaries.update_slip(slip, slip_params) do
      {:ok, slip} ->
        conn
        |> put_flash(:info, "Slip updated successfully.")
        |> redirect(to: Routes.slip_path(conn, :show, slip))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", slip: slip, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    slip = Salaries.get_slip!(id)
    {:ok, _slip} = Salaries.delete_slip(slip)

    conn
    |> put_flash(:info, "Slip deleted successfully.")
    |> redirect(to: Routes.slip_path(conn, :index))
  end
end
